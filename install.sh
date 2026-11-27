#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Error: please run the script with root privileges (sudo ./install.sh)"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
SO_FILE="$SCRIPT_DIR/usr/lib/x86_64-linux-gnu/qt6/plugins/discover/cpak-backend.so"
XML_FILE="$SCRIPT_DIR/usr/share/libdiscover/categories/cpak-backend-categories.xml"

if [ ! -f "$SO_FILE" ] || [ ! -f "$XML_FILE" ]; then
    echo "Error: plugin files not found next to the script."
    exit 1
fi

# 1. Detect the system Qt6 plugins directory in the user's distribution
QT_PLUGIN_DIR=""
if command -v qtpaths6 >/dev/null 2>&1; then
    QT_PLUGIN_DIR="$(qtpaths6 --plugin-dir)"
elif command -v qtpaths >/dev/null 2>&1; then
    QT_PLUGIN_DIR="$(qtpaths --plugin-dir)"
else
    # Fallback option if qtpaths is not installed
    for dir in /usr/lib/x86_64-linux-gnu/qt6/plugins /usr/lib64/qt6/plugins /usr/lib/qt6/plugins; do
        if [ -d "$dir/discover" ]; then
            QT_PLUGIN_DIR="$dir"
            break
        fi
    done
fi

if [ -z "$QT_PLUGIN_DIR" ]; then
    echo "Error: could not find the Qt6 plugins directory."
    exit 1
fi

DISCOVER_PLUGIN_DIR="$QT_PLUGIN_DIR/discover"
CATEGORIES_DIR="/usr/share/libdiscover/categories"

echo "Installing cpak-backend.so into $DISCOVER_PLUGIN_DIR ..."
install -Dm755 "$SO_FILE" "$DISCOVER_PLUGIN_DIR/cpak-backend.so"

echo "Installing cpak-backend-categories.xml into $CATEGORIES_DIR ..."
install -Dm644 "$XML_FILE" "$CATEGORIES_DIR/cpak-backend-categories.xml"

echo "Done! Restart KDE Discover (killall plasma-discover) to apply the changes."
