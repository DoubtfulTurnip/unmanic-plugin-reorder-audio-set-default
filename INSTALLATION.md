# Installation Instructions

## ✅ Repository Now Supports UI Installation!

This repository has been restructured as a proper Unmanic plugin repository. You can now install it via the Unmanic UI!

## Method 1: Install via Unmanic UI (Recommended)

This is the easiest method and allows automatic updates.

### Step 1: Add the Repository

1. Open Unmanic web UI
2. Go to **Settings** → **Plugins**
3. Click **Install Plugin from Repo** button
4. Click **ADD REPOSITORY**
5. Enter this URL:
   ```
   https://raw.githubusercontent.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/repo/repo.json
   ```
6. Click **SAVE**

### Step 2: Install the Plugin

1. The plugin **"Re-order audio streams by language and set default"** should now appear in the available plugins list
2. Click the **INSTALL** button next to it
3. Wait for installation to complete

### Step 3: Configure the Plugin

1. Find the plugin in your installed plugins list
2. Toggle it **ON** to enable it
3. Click the **settings icon** (⚙️)
4. Set **Search String** to `eng` or `en` (or your preferred language code)
5. (Optional) Configure Radarr/Sonarr integration if needed
6. Click **SAVE**

### Step 4: Test

1. Go to your Library
2. Click **Scan** to test files
3. Files with English audio first but missing default flag will now be processed!

---

## Method 2: Manual Installation

If you prefer manual installation or the UI method doesn't work:

### Step 1: Clone the Repository

SSH into your server (or Docker container) and run:

```bash
cd /tmp
git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git
cd unmanic-plugin-reorder-audio-set-default
git submodule update --init --recursive
```

### Step 2: Copy Plugin to Unmanic Directory

```bash
cp -r source/reorder_audio_streams_by_language_set_default /path/to/unmanic/config/plugins/
```

**For Docker users**, exec into the container first:

```bash
# Clone on host or inside container
docker exec -it unmanic bash

# Inside container:
cd /tmp
git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git
cd unmanic-plugin-reorder-audio-set-default
git submodule update --init --recursive
cp -r source/reorder_audio_streams_by_language_set_default /config/plugins/
cd /
rm -rf /tmp/unmanic-plugin-reorder-audio-set-default
exit
```

### Step 3: Install Dependencies (Usually Automatic)

Unmanic typically installs dependencies automatically. If needed manually:

```bash
pip3 install -r /config/plugins/reorder_audio_streams_by_language_set_default/requirements.txt
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
4. Toggle it **ON**
5. Click the settings icon to configure:
   - Set **Search String** to `eng` or `en`
   - (Optional) Configure Radarr/Sonarr integration

### Step 6: Run Library Scan

1. Go to your Library
2. Click **Scan** to test files
3. The plugin will now process files even when English audio is first but the default flag is missing

---

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
