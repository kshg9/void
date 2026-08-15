#!/usr/bin/env bash
# Build the installer ISO and link it to $HOME
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")/.."

dest="${1:-$HOME/urielOS.iso}"

echo "Building installer ISO..."
store_path=$(nix --extra-experimental-features 'nix-command flakes' build \
  --print-out-paths \
  --no-link \
  '.#nixosConfigurations.installer.config.system.build.isoImage')

# Find the exact .iso file inside the nix store output
iso_file=$(ls "$store_path"/iso/*.iso | head -n 1)

echo "Linking ISO to $dest..."
ln -sf "$iso_file" "$dest"

echo
echo "=== ISO ready: $dest ==="
echo "Write to USB: sudo dd if=$dest of=/dev/sdX bs=1M status=progress"
