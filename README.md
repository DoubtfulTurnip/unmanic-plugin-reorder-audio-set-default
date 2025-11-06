# Unmanic Plugin: Re-order Audio Streams by Language and Set Default

**Status:** ✅ **Working and Tested**

A modified version of the original [reorder_audio_streams_by_language](https://github.com/Unmanic/plugin.reorder_audio_streams_by_language) plugin that fixes a critical limitation.

## The Problem This Solves

The original plugin **skips files** where the desired language audio is already in the first position, even if the **default flag** is not set. This is a common issue with anime collections where English audio is listed first but not marked as the default track.

## Key Difference

**Original Plugin:**
- ❌ Skips files if the language order is already correct
- ❌ Doesn't check or set the default disposition flag
- ❌ Leaves anime with English audio first but no default flag untouched

**This Modified Plugin:**
- ✅ Processes files even when the language order is correct
- ✅ Checks if the default disposition flag is set
- ✅ Sets the default flag on the first matching audio stream
- ✅ Fixes anime collections with correct order but missing default flag

## Features

- Re-orders audio streams to prioritize a specified language
- **Always sets the default disposition flag** on the first matching audio stream
- Processes files even when order is correct but default flag is missing
- Supports manual language specification or automatic detection via Radarr/Sonarr
- Uses FFmpeg for stream manipulation (copy mode - no re-encoding)

## Installation

### Download & Install

1. **Download the plugin:**
   - **[Download reorder_audio_streams_by_language_set_default.zip](https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/raw/master/reorder_audio_streams_by_language_set_default.zip)**

2. **Install in Unmanic:**
   - Open Unmanic Web UI
   - Go to **Settings** → **Plugins**
   - Click **"Install Plugin from File"** or **"Upload Plugin"**
   - Select the downloaded `reorder_audio_streams_by_language_set_default.zip` file
   - Click **Install**

3. **Enable and Configure:**
   - Find **"Re-order audio streams by language and set default"** in your plugin list
   - Toggle it **ON**
   - Click the ⚙️ **settings icon**
   - Set **Search String** to `eng` (or your preferred language code)
   - (Optional) Configure Radarr/Sonarr integration if needed
   - Click **Save**

4. **Run a Library Scan:**
   - Go to your Library
   - Click **Scan**
   - Files with the correct audio order but missing default flag will now be processed!

## Configuration

In the plugin settings:

- **Search String**: Enter a language code (e.g., "eng", "en", "jpn", "fr", "de")
  - This is typically a 3-letter ISO 639-2 code
  - Will be ignored if Radarr or Sonarr integration is enabled

- **Radarr Integration** (optional):
  - Enable to automatically use the original language from Radarr
  - Requires Radarr URL and API key

- **Sonarr Integration** (optional):
  - Enable to automatically use the original language from Sonarr
  - Requires Sonarr URL and API key

## How It Works

The plugin performs two checks:

1. **Stream Order Check**: Is the desired language audio stream in the first position?
2. **Default Flag Check**: Does the first matching audio stream have the default disposition flag set?

Files will be processed if:
- The audio stream order needs to be changed, **OR**
- The default flag is not set on the first matching audio stream

This ensures all your media files have both:
- ✅ Correct audio stream order
- ✅ Default flag properly set

## Technical Details

- Uses FFmpeg with `-c copy` (no re-encoding)
- Checks stream disposition flags in file probe data
- Sets `-disposition:a:0 default` on the first matching audio stream
- Clears default flag from other audio streams with `-disposition:a -default`

## Example Scenarios

### Scenario 1: Order Wrong, Default on Wrong Track
- **Current:** Japanese (default ✓), English (no flag)
- **Action:** Reorder streams AND set default flag
- **Result:** English (default ✓), Japanese (no flag)

### Scenario 2: Order Correct, Default on Wrong Track ⭐ **NEW BEHAVIOR**
- **Current:** English (no flag), Japanese (default ✓)
- **Action:** Keep order, fix default flag
- **Result:** English (default ✓), Japanese (no flag)
- **Original plugin would skip this file!** ❌

### Scenario 3: Order Correct, No Default Flag Set ⭐ **NEW BEHAVIOR**
- **Current:** English (no flag), Japanese (no flag)
- **Action:** Keep order, set default flag
- **Result:** English (default ✓), Japanese (no flag)
- **Original plugin would skip this file!** ❌

### Scenario 4: Already Perfect
- **Current:** English (default ✓), Japanese (no flag)
- **Action:** None
- **Result:** File skipped (no processing needed)

## Requirements

- Unmanic (any recent version)
- Python dependencies (bundled in the plugin zip):
  - pyarr==5.2.0
  - pycountry==24.6.1

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions, including:
- Plugin doesn't appear after installation
- Docker permissions issues on TrueNAS/Unraid
- Manual installation methods

## Credits & Acknowledgments

**This plugin is a modified version** of the excellent [reorder_audio_streams_by_language](https://github.com/Unmanic/plugin.reorder_audio_streams_by_language) plugin created by **Josh.5** (jsunnex@gmail.com).

### What's Changed
- Added default disposition flag checking and setting
- Modified logic to process files even when stream order is already correct
- Bundled Python dependencies for easier deployment

### Special Thanks
Huge thanks to **Josh.5** for creating the original plugin and the entire Unmanic ecosystem. This modification wouldn't exist without that foundation.

**Original Plugin Repository:** https://github.com/Unmanic/plugin.reorder_audio_streams_by_language

**Modified By:** DoubtfulTurnip

## License

GNU General Public License v3.0

See [LICENSE](LICENSE) file for details.

## Support

For issues with this modified version:
- Open an issue on [GitHub](https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/issues)

For general Unmanic support:
- Visit the [Unmanic Discord](https://unmanic.app/discord)
