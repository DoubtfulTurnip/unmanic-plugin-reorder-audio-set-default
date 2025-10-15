# Unmanic Plugin: Re-order Audio Streams by Language and Set Default

This is a modified version of the original [reorder_audio_streams_by_language](https://github.com/Unmanic/plugin.reorder_audio_streams_by_language) plugin.

## Key Difference

**Unlike the original plugin**, this version will process files even when the desired language audio stream is already in the first position, as long as the **default disposition flag** is not set.

## Use Case

This plugin is particularly useful for anime collections or other media where:
- The English (or preferred language) audio is already the first audio stream
- BUT the default flag has not been set
- The original plugin would skip these files, leaving them without the default audio track properly marked

## Features

- Re-orders audio streams to prioritize a specified language
- Sets the default disposition flag on the first matching audio stream
- Processes files even when order is correct but default flag is missing
- Supports manual language specification or automatic detection via Radarr/Sonarr
- Uses FFmpeg for stream manipulation (copy mode - no re-encoding)

## Installation

### Option 1: Install from Zip File (Easiest) ⭐

1. Download the plugin zip file:
   - **[Download reorder_audio_streams_by_language_set_default.zip](https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/raw/master/reorder_audio_streams_by_language_set_default.zip)**

2. In Unmanic UI, go to **Settings** → **Plugins**
3. Click **"Install Plugin from File"** (or similar button)
4. Select the downloaded zip file
5. Click **Install**
6. Enable and configure the plugin (Search String = `eng`)

### Option 2: Install via Repository (If UI method doesn't work)

1. In Unmanic, go to **Settings** → **Plugins** → **Install Plugin from Repo**
2. Click **ADD REPOSITORY**
3. Enter the repository URL:
   ```
   https://raw.githubusercontent.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/repo/repo.json
   ```
4. Click **SAVE**
5. Find **"Re-order audio streams by language and set default"** in the plugin list
6. Click **INSTALL**
7. Enable and configure the plugin

### Option 3: Manual Installation

1. SSH into your Unmanic server/container
2. Navigate to your Unmanic plugins directory (usually `/config/plugins`)
3. Clone the plugin from the source directory:
   ```bash
   git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git temp_clone
   cd temp_clone
   git submodule update --init --recursive
   cp -r source/reorder_audio_streams_by_language_set_default /config/plugins/
   cd ..
   rm -rf temp_clone
   ```

4. Restart Unmanic
5. Enable the plugin in Settings → Plugins

**See [INSTALLATION.md](INSTALLATION.md) for detailed Docker instructions and troubleshooting.**

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
- The audio stream order needs to be changed, OR
- The default flag is not set on the first matching audio stream

This ensures all your media files have both:
- Correct audio stream order
- Default flag properly set

## Technical Details

- Uses FFmpeg with `-c copy` (no re-encoding)
- Checks stream disposition flags in file probe data
- Sets `-disposition:a:0 default` on the first matching audio stream
- Clears default flag from other audio streams with `-disposition:a -default`

## Example Scenarios

### Scenario 1: Order Wrong, No Default Flag
- Current: Japanese (no flag), English (no flag)
- Result: English (default), Japanese (no flag)

### Scenario 2: Order Correct, No Default Flag ⭐ (This is the new behavior!)
- Current: English (no flag), Japanese (no flag)
- Result: English (default), Japanese (no flag)
- **Original plugin would skip this file!**

### Scenario 3: Order Correct, Default Flag Set
- Current: English (default), Japanese (no flag)
- Result: File skipped (no processing needed)

## Requirements

- Python dependencies (installed automatically by Unmanic):
  - pyarr>=5.2.0
  - pycountry>=24.6.1

## Credits

- Original plugin by Josh.5 (jsunnex@gmail.com)
- Modified to add default flag checking functionality

## License

GNU General Public License v3.0

See LICENSE file for details.

## Support

For issues specific to this modified version, please open an issue in this repository.

For general Unmanic plugin support, visit the [Unmanic Discord](https://unmanic.app/discord).
