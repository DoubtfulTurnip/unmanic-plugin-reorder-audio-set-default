# Troubleshooting "New repository failed to save" Error

## The Real Issue

The "New repository failed to save" error in Unmanic is **NOT** a repository structure problem. It's a **Docker permissions issue** with your Unmanic container.

The error occurs because Unmanic cannot write to its database file due to insufficient permissions on the `/config` directory.

## Diagnosis Steps

### Step 1: Check Unmanic Logs

```bash
# View Unmanic container logs
docker logs unmanic

# Or if using docker-compose
docker-compose logs unmanic

# Look for errors like:
# sqlite3.OperationalError: unable to open database file
```

### Step 2: Check Config Directory Permissions

```bash
# Find where your Unmanic config is mounted (check your docker-compose.yml or docker run command)
# Then check permissions on the host

ls -la /path/to/your/unmanic/config

# Check ownership - should match your PUID/PGID
```

### Step 3: Check PUID/PGID Environment Variables

```bash
# Check what user Unmanic is running as
docker exec unmanic id

# Check your Docker environment variables
docker inspect unmanic | grep -A 5 "Env"

# Look for PUID and PGID values
```

## Solution: Fix Permissions

### Option 1: Fix Ownership on Host (Recommended)

1. **Stop the Unmanic container:**
   ```bash
   docker stop unmanic
   ```

2. **Find your user ID and group ID:**
   ```bash
   id -u  # Your PUID
   id -g  # Your PGID
   ```

3. **Fix ownership of the config directory:**
   ```bash
   # Replace with your actual config path and PUID:PGID
   sudo chown -R 1000:1000 /path/to/unmanic/config

   # Or use your username:
   sudo chown -R $USER:$USER /path/to/unmanic/config
   ```

4. **Verify permissions:**
   ```bash
   ls -la /path/to/unmanic/config
   # Should show your user as owner
   ```

5. **Restart Unmanic:**
   ```bash
   docker start unmanic
   ```

### Option 2: Set Correct PUID/PGID in Docker

If using Docker Compose, edit your `docker-compose.yml`:

```yaml
services:
  unmanic:
    image: josh5/unmanic:latest
    environment:
      - PUID=1000    # Your user ID from 'id -u'
      - PGID=1000    # Your group ID from 'id -g'
    volumes:
      - /path/to/config:/config
    # ... rest of config
```

Then recreate the container:

```bash
docker-compose down
docker-compose up -d
```

### Option 3: Nuclear Option - Reset Permissions

If nothing else works:

```bash
# Stop container
docker stop unmanic

# Make config directory world-writable (temporary, not recommended for production)
sudo chmod -R 777 /path/to/unmanic/config

# Start container
docker start unmanic

# Try adding repository again

# If it works, fix permissions properly:
docker stop unmanic
sudo chown -R 1000:1000 /path/to/unmanic/config
sudo chmod -R 755 /path/to/unmanic/config
docker start unmanic
```

## Verify the Fix

After fixing permissions:

1. **Check Unmanic can write to config:**
   ```bash
   # Inside the container
   docker exec unmanic touch /config/test_write
   docker exec unmanic ls -la /config/test_write
   docker exec unmanic rm /config/test_write
   ```

   If this fails, permissions are still wrong.

2. **Try adding repository again:**
   - Go to Unmanic UI → Settings → Plugins
   - Click ADD REPOSITORY
   - Enter: `https://raw.githubusercontent.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default/repo/repo.json`
   - Click SAVE

   Should work now!

## Common Mistakes

❌ **Wrong PUID/PGID:** Using root (0:0) or mismatched IDs
❌ **Config on NFS/CIFS mount:** Some filesystems don't support proper permissions
❌ **SELinux blocking writes:** If using SELinux, may need `:z` volume flag
❌ **Snap/Flatpak Docker:** May have additional permission restrictions

## Alternative: Manual Plugin Installation

If you **still** can't get repository installation working, install the plugin manually:

```bash
# Exec into container
docker exec -it unmanic bash

# Clone plugin to plugins directory
cd /config/plugins
git clone --recursive https://github.com/DoubtfulTurnip/unmanic-plugin-reorder-audio-set-default.git temp
cp -r temp/source/reorder_audio_streams_by_language_set_default .
rm -rf temp

# Exit and restart
exit
docker restart unmanic
```

Then enable it in the Unmanic UI under Settings → Plugins.

## Still Not Working?

### Check Your Docker Setup

**Find your docker-compose.yml or docker run command:**
```bash
# For docker-compose
cat docker-compose.yml

# For plain docker, find the container
docker inspect unmanic
```

**Share this info:**
- Output of `docker inspect unmanic | grep -A 10 Mounts`
- Output of `ls -la /path/to/config`
- Output of `docker logs unmanic | tail -50`

### Check Unmanic Version

```bash
docker exec unmanic cat /usr/local/bin/unmanic/version.txt
```

Ensure you're on a recent version (v0.2.0+).

## Example Working Configuration

Here's a working `docker-compose.yml` example:

```yaml
version: '3'
services:
  unmanic:
    image: josh5/unmanic:latest
    container_name: unmanic
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /path/on/host/unmanic/config:/config
      - /path/to/media:/library
    ports:
      - "8888:8888"
    restart: unless-stopped
```

The key is ensuring PUID/PGID match the owner of `/path/on/host/unmanic/config`.
