#!/bin/bash

# Audio Stream Checker for Media Libraries
# Checks for:
# 1. Files where English audio is NOT set as default
# 2. Files with NO English audio track at all

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_files=0
no_english_audio=0
english_not_default=0
english_is_default=0
errors=0

# Arrays to store results
declare -a files_no_english
declare -a files_english_not_default
declare -a files_english_is_default
declare -a error_files

# Check if directory is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory_path>"
    echo "Example: $0 /A/Animated"
    exit 1
fi

LIBRARY_PATH="$1"

# Check if directory exists
if [ ! -d "$LIBRARY_PATH" ]; then
    echo -e "${RED}Error: Directory '$LIBRARY_PATH' does not exist${NC}"
    exit 1
fi

# Check if ffprobe is available
if ! command -v ffprobe &> /dev/null; then
    echo -e "${RED}Error: ffprobe is not installed or not in PATH${NC}"
    echo "Install ffmpeg package to get ffprobe"
    exit 1
fi

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Audio Stream Checker for Unmanic Libraries${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Scanning directory: $LIBRARY_PATH"
echo ""

# Function to check audio streams in a file
check_file() {
    local file="$1"
    local filename=$(basename "$file")

    # Get audio streams info from ffprobe
    local probe_output
    if ! probe_output=$(ffprobe -v quiet -print_format json -show_streams -select_streams a "$file" 2>&1); then
        ((errors++))
        error_files+=("$file")
        return
    fi

    # Parse JSON to find English audio streams
    local has_english=false
    local english_is_default_flag=false
    local default_stream_lang=""
    local audio_stream_count=0

    # Count total audio streams
    audio_stream_count=$(echo "$probe_output" | grep -c '"codec_type": "audio"' || echo "0")

    if [ "$audio_stream_count" -eq 0 ]; then
        # No audio streams at all
        ((no_english_audio++))
        files_no_english+=("$file (No audio streams)")
        return
    fi

    # Check each audio stream
    local stream_index=0
    while true; do
        # Get language tag for this stream
        local lang=$(echo "$probe_output" | jq -r ".streams[$stream_index].tags.language // \"und\"" 2>/dev/null)

        # Break if no more streams
        if [ "$lang" = "null" ] || [ -z "$lang" ]; then
            break
        fi

        # Get default disposition
        local is_default=$(echo "$probe_output" | jq -r ".streams[$stream_index].disposition.default // 0" 2>/dev/null)

        # Check if this is an English stream
        if [[ "$lang" =~ ^(eng|en)$ ]]; then
            has_english=true
            if [ "$is_default" = "1" ]; then
                english_is_default_flag=true
            fi
        fi

        # Track which language has default flag
        if [ "$is_default" = "1" ]; then
            default_stream_lang="$lang"
        fi

        ((stream_index++))
    done

    # Categorize the file
    if [ "$has_english" = false ]; then
        ((no_english_audio++))
        files_no_english+=("$file")
    elif [ "$english_is_default_flag" = false ]; then
        ((english_not_default++))
        if [ -n "$default_stream_lang" ]; then
            files_english_not_default+=("$file (default: $default_stream_lang)")
        else
            files_english_not_default+=("$file (no default set)")
        fi
    else
        ((english_is_default++))
        files_english_is_default+=("$file")
    fi
}

# Find and process all video files
echo -e "${YELLOW}Scanning for video files...${NC}"
echo ""

while IFS= read -r -d '' file; do
    ((total_files++))
    printf "\rProcessing: %d files..." "$total_files"
    check_file "$file"
done < <(find "$LIBRARY_PATH" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.m4v" \) -print0)

echo ""
echo ""

# Print results
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}RESULTS${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${GREEN}Total files scanned: $total_files${NC}"
echo ""

# Files with no English audio
if [ "$no_english_audio" -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}Files with NO English audio: $no_english_audio${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    for file in "${files_no_english[@]}"; do
        echo -e "  ${RED}✗${NC} $file"
    done
    echo ""
fi

# Files where English is not default
if [ "$english_not_default" -gt 0 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Files where English is NOT default: $english_not_default${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    for file in "${files_english_not_default[@]}"; do
        echo -e "  ${YELLOW}⚠${NC} $file"
    done
    echo ""
fi

# Files where English is default (all good)
if [ "$english_is_default" -gt 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Files where English IS default: $english_is_default${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ These files are correctly configured${NC}"
    echo ""
fi

# Errors
if [ "$errors" -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}Files with errors: $errors${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    for file in "${error_files[@]}"; do
        echo -e "  ${RED}✗${NC} $file"
    done
    echo ""
fi

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}SUMMARY${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Total files processed:           $total_files"
echo -e "${RED}No English audio:                $no_english_audio${NC}"
echo -e "${YELLOW}English exists but not default:  $english_not_default${NC}"
echo -e "${GREEN}English is default (correct):    $english_is_default${NC}"
if [ "$errors" -gt 0 ]; then
    echo -e "${RED}Errors:                          $errors${NC}"
fi
echo ""

# Create detailed report file
REPORT_FILE="audio_check_report_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "Audio Stream Check Report"
    echo "Generated: $(date)"
    echo "Directory: $LIBRARY_PATH"
    echo ""
    echo "================================"
    echo "SUMMARY"
    echo "================================"
    echo "Total files: $total_files"
    echo "No English audio: $no_english_audio"
    echo "English not default: $english_not_default"
    echo "English is default: $english_is_default"
    if [ "$errors" -gt 0 ]; then
        echo "Errors: $errors"
    fi
    echo ""

    if [ "$no_english_audio" -gt 0 ]; then
        echo "================================"
        echo "FILES WITH NO ENGLISH AUDIO"
        echo "================================"
        for file in "${files_no_english[@]}"; do
            echo "$file"
        done
        echo ""
    fi

    if [ "$english_not_default" -gt 0 ]; then
        echo "================================"
        echo "FILES WHERE ENGLISH NOT DEFAULT"
        echo "================================"
        for file in "${files_english_not_default[@]}"; do
            echo "$file"
        done
        echo ""
    fi

    if [ "$errors" -gt 0 ]; then
        echo "================================"
        echo "FILES WITH ERRORS"
        echo "================================"
        for file in "${error_files[@]}"; do
            echo "$file"
        done
        echo ""
    fi
} > "$REPORT_FILE"

echo -e "${GREEN}Detailed report saved to: $REPORT_FILE${NC}"
echo ""

# Actionable recommendations
if [ "$no_english_audio" -gt 0 ] || [ "$english_not_default" -gt 0 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}RECOMMENDATIONS${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ "$english_not_default" -gt 0 ]; then
        echo -e "• ${YELLOW}$english_not_default files${NC} have English audio but it's not set as default"
        echo "  → Run these files through Unmanic with the plugin enabled"
    fi

    if [ "$no_english_audio" -gt 0 ]; then
        echo -e "• ${RED}$no_english_audio files${NC} have no English audio track"
        echo "  → These need manual review or re-downloading with English audio"
    fi
    echo ""
fi
