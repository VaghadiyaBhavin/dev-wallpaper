#!/bin/bash
# Build dist/dev-wallpaper_<version>_all.deb from src/
set -euo pipefail
cd "$(dirname "$0")"
version=$(sed -n 's/^Version: //p' src/DEBIAN/control)
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
cp -a src/. "$stage/"
find "$stage" -name __pycache__ -prune -exec rm -rf {} +
chmod 0755 "$stage/DEBIAN/postinst" "$stage/DEBIAN/prerm" "$stage/usr/bin/"*
find "$stage/usr" -type f ! -path '*/bin/*' -exec chmod 0644 {} +
find "$stage" -type d -exec chmod 0755 {} +
mkdir -p dist
dpkg-deb --root-owner-group --build "$stage" "dist/dev-wallpaper_${version}_all.deb"
echo "Install with:  sudo apt install ./dist/dev-wallpaper_${version}_all.deb"
