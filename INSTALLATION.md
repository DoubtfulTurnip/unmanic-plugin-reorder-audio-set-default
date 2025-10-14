# Installation Instructions

## Issue with Repository Installation

The "New repository failed to save" error occurs because this repository is structured as a **single plugin**, not a **plugin repository**.

Unmanic's "Add Repository" feature expects a plugin repository (like the official unmanic-plugins repo) with multiple plugins, a `repo.json` file, and specific structure. Our repository contains just one plugin.

## Manual Installation (Recommended)

Follow these steps to install the plugin manually:

### Step 1: Find Your Unmanic Plugins Directory

Your Unmanic plugins directory is typically located at:
- **Docker**: `/config/plugins` (inside the container) or your mapped config volume
- **Bare metal**: `~/.unmanic/plugins` or check your Unmanic config

### Step 2: Clone the Plugin

SSH into your server (or Docker container) and run:

```bash
cd /path/to/unmanic/config/plugins
git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git reorder_audio_streams_by_language_set_default
```

**Important**: The directory name must match the plugin ID: `reorder_audio_streams_by_language_set_default`

### Step 3: Install Dependencies

```bash
cd reorder_audio_streams_by_language_set_default
pip3 install -r requirements.txt
```

Or if Unmanic runs in Docker, exec into the container first:

```bash
docker exec -it unmanic bash
cd /config/plugins
git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git reorder_audio_streams_by_language_set_default
pip3 install -r /config/plugins/reorder_audio_streams_by_language_set_default/requirements.txt
exit
```

### Step 4: Restart Unmanic

Restart the Unmanic service or Docker container:

```bash
# Docker
docker restart unmanic

# Systemd
sudo systemctl restart unmanic
```

### Step 5: Enable the Plugin

1. Open Unmanic web UI
2. Go to **Settings** → **Plugins**
3. Find **"Re-order audio streams by language and set default"**
4. Click the toggle to enable it
5. Click the settings icon to configure:
   - Set **Search String** to `eng` or `en`
   - (Optional) Configure Radarr/Sonarr integration

### Step 6: Run Library Scan

1. Go to your Library
2. Click **Scan** to test files
3. The plugin will now process files even when English audio is first but the default flag is missing

## Alternative: Create a Plugin Repository (Future Enhancement)

If you want to install via the UI "Add Repository" feature, we would need to:

1. Restructure this repository to match the official plugin repository format
2. Add `source/reorder_audio_streams_by_language_set_default/` directory structure
3. Create `config.json` in the root
4. Set up GitHub Actions to generate `repo.json`

Let me know if you'd like me to create this structure instead.

## Troubleshooting

### Plugin doesn't appear after installation
- Verify the directory name matches the plugin ID exactly
- Check Unmanic logs for errors: `docker logs unmanic` or check `/config/unmanic.log`
- Ensure dependencies installed correctly

### Permission errors
- Ensure the plugin directory has correct ownership
- For Docker: `chown -R <PUID>:<PGID> /path/to/config/plugins/reorder_audio_streams_by_language_set_default`

### Import errors
- Verify the `lib/ffmpeg` submodule was cloned: `ls lib/ffmpeg/` should show multiple Python files
- If empty, run: `git submodule update --init --recursive`
