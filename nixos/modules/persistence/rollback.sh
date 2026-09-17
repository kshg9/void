set -euo pipefail

: "${ROLLBACK_DEVICE:?Missing rollback device}"
mount_dir="${ROLLBACK_MOUNT:-/run/root-rollback}"
mkdir -p "$mount_dir"
mount -t btrfs -o subvolid=5 -- "$ROLLBACK_DEVICE" "$mount_dir"

cleanup() {
  local status=$?
  trap - EXIT
  if ! umount "$mount_dir"; then
    if (( status == 0 )); then status=1; fi
  fi
  exit "$status"
}
trap cleanup EXIT

blank="$mount_dir/root-blank"
root="$mount_dir/root"
next="$mount_dir/root-next"

for candidate in "$blank" "$root" "$next"; do
  if [[ -L "$candidate" ]]; then
    echo "Refusing to roll back a symlink: $candidate" >&2
    exit 1
  fi
done

# Validate and protect the template before touching the current root.
btrfs subvolume show "$blank" >/dev/null
btrfs property set -ts "$blank" ro true

if [[ -e "$root" ]]; then
  btrfs subvolume show "$root" >/dev/null
fi

# A power loss can leave the prepared replacement from an earlier boot.
if [[ -e "$next" ]]; then
  btrfs subvolume show "$next" >/dev/null
  btrfs subvolume delete --recursive --commit-after "$next"
fi

echo "Preparing a fresh root snapshot..."
btrfs subvolume snapshot "$blank" "$next"

if [[ -e "$root" ]]; then
  echo "Deleting the old root and its nested subvolumes..."
  btrfs subvolume delete --recursive --commit-after "$root"
fi

mv -- "$next" "$root"
btrfs filesystem sync "$mount_dir"
