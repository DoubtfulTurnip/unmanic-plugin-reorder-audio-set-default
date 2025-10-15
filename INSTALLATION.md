# Installation Instructions

## Simple Installation (Recommended)

### Step 1: Download the Plugin

Download the plugin zip file:
- **[Download reorder_audio_streams_by_language_set_default.zip](https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/raw/master/reorder_audio_streams_by_language_set_default.zip)**

### Step 2: Install via Unmanic UI

1. Open Unmanic Web UI
2. Go to **Settings** → **Plugins**
3. Click **"Install Plugin from File"** or **"Upload Plugin"** button
4. Browse and select the downloaded `reorder_audio_streams_by_language_set_default.zip` file
5. Click **Install** or **Upload**

### Step 3: Enable and Configure

1. The plugin **"Re-order audio streams by language and set default"** should now appear in your plugin list
2. Toggle it **ON** to enable it
3. Click the **⚙️ settings icon**
4. Set **Search String** to `eng` (or your preferred language code)
5. (Optional) Configure Radarr/Sonarr integration if needed
6. Click **SAVE**

### Step 4: Test

1. Go to your Library
2. Click **Scan** to test files
3. Files with the correct audio order but missing default flag will now be processed!

---

## Manual Installation (Alternative)

If the UI installation doesn't work, you can manually install the plugin:

### For Docker/TrueNAS SCALE

```bash
# Exec into your Unmanic container
docker exec -it <unmanic-container-name> bash

# Navigate to plugins directory
cd /config/.unmanic/plugins

# Download and extract the plugin
curl -L https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/raw/master/reorder_audio_streams_by_language_set_default.zip -o plugin.zip
python3 -m zipfile -e plugin.zip .
rm plugin.zip

# Fix permissions
chown -R abc:abc reorder_audio_streams_by_language_set_default

# Install Python dependencies (if not auto-installed)
pip3 install pyarr==5.2.0 pycountry==24.6.1

# Exit container
exit

# Restart Unmanic
docker restart <unmanic-container-name>
```

### For Bare Metal Installation

```bash
# Navigate to Unmanic plugins directory
cd ~/.unmanic/plugins  # or your custom plugin directory

# Download and extract the plugin
wget https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/raw/master/reorder_audio_streams_by_language_set_default.zip
unzip reorder_audio_streams_by_language_set_default.zip
rm reorder_audio_streams_by_language_set_default.zip

# Install Python dependencies (if not auto-installed)
pip3 install pyarr==5.2.0 pycountry==24.6.1

# Restart Unmanic service
sudo systemctl restart unmanic
```

---

## Verification

After installation and restart, verify the plugin is working:

1. **Check Unmanic logs:**
   ```bash
   # Docker
   docker exec <unmanic-container-name> tail -50 /config/.unmanic/logs/unmanic.log

   # Bare metal
   tail -50 ~/.unmanic/logs/unmanic.log
   ```

2. **Check plugin directory:**
   ```bash
   # Docker
   docker exec <unmanic-container-name> ls -la /config/.unmanic/plugins/reorder_audio_streams_by_language_set_default/

   # Bare metal
   ls -la ~/.unmanic/plugins/reorder_audio_streams_by_language_set_default/
   ```

3. **Verify in UI:**
   - Open Unmanic → Settings → Plugins
   - Look for **"Re-order audio streams by language and set default"**
   - Should appear in your plugin list

---

## Common Issues

### Plugin doesn't appear after installation

**Solution:** Create a settings.json file:

```bash
# Docker
docker exec <unmanic-container-name> bash -c 'echo "{}" > /config/.unmanic/plugins/reorder_audio_streams_by_language_set_default/settings.json'
docker exec <unmanic-container-name> chown abc:abc /config/.unmanic/plugins/reorder_audio_streams_by_language_set_default/settings.json
docker restart <unmanic-container-name>

# Bare metal
echo "{}" > ~/.unmanic/plugins/reorder_audio_streams_by_language_set_default/settings.json
sudo systemctl restart unmanic
```

### Missing Python dependencies

**Solution:** Install them manually:

```bash
# Docker
docker exec <unmanic-container-name> pip3 install pyarr==5.2.0 pycountry==24.6.1
docker restart <unmanic-container-name>

# Bare metal
pip3 install pyarr==5.2.0 pycountry==24.6.1
sudo systemctl restart unmanic
```

### Permission errors

**Solution:** Fix ownership:

```bash
# Docker (abc user is UID 568 in linuxserver.io images)
docker exec <unmanic-container-name> chown -R abc:abc /config/.unmanic/plugins/reorder_audio_streams_by_language_set_default

# Bare metal
chown -R $USER:$USER ~/.unmanic/plugins/reorder_audio_streams_by_language_set_default
```

---

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
