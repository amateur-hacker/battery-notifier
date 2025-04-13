# 🔋 Battery Notifier

A minimal battery monitoring script for Linux with voice + desktop notifications.

## ✅ Features

- Alerts when battery is **<15%** (low) or **>90%** (charged)
- Voice alerts using `mpv`
- Desktop notifications via `notify-send`
- Background-safe: avoids duplicate instances

## 📦 Installation

```bash
git clone https://github.com/amateur-hacker/battery-notifier.git
cd battery-notifier
chmod +x install.sh
./install.sh
```

The installer will:

- Prompt for confirmation
- Detect your package manager and install: `acpi`, `mpv`, `libnotify`
- Copy audio files to `~/.local/share/battery-notifier/`
- Install script to `~/.local/bin/battery-notifier`

## 🚀 Auto Start on Boot

A `.desktop` file is already included.

### For Desktop Environments

```bash
mkdir -p ~/.config/autostart
cp battery-notifier.desktop ~/.config/autostart
```

### For Window Managers

Add this to your WM autostart (e.g., i3, bspwmrc):

```bash
setsid -f $HOME/.local/bin/battery-notifier >/dev/null 2>&1 &
```
