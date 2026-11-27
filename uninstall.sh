#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Error: please run the script with root privileges (sudo ./uninstall.sh)"
    exit 1
fi

echo "Removing cpak-backend..."
find /usr/lib* -path "*/qt6/plugins/discover/cpak-backend.so" -delete 2>/dev/null || true
rm -f /usr/share/libdiscover/categories/cpak-backend-categories.xml
echo "Removed. Restart KDE Discover."
