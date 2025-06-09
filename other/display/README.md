# Plasma PowerDevil Brightness Fix

## Issue

Monitor brightness resets on every monitor wakeup.
https://bugs.kde.org/show_bug.cgi?id=494408

External monitor brightness control sometimes fails after suspend/resume because plasma-powerdevil restarts before the monitor is fully awake.

## Solution
Smart monitor detection in `/usr/lib/systemd/system-sleep/powerdevil-restart`:
- Uses `kscreen-doctor` to detect when external monitors come online (Wayland)
- Waits up to 10 seconds, checking every second
- Restarts powerdevil as soon as monitors are detected or after timeout
- Runs asynchronously to not block the wakeup/login process

## Deploy

```bash
sudo cp powerdevil-restart /usr/lib/systemd/system-sleep/
```
