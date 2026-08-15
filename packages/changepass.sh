#!/usr/bin/env bash
set -euo pipefail

PROG="changepass"
DEST_DIR="/persist/passwords"

die() {
  printf '%s: %s\n' "$PROG" "$*" >&2
  exit 1
}

if [ "$(id -u)" -ne 0 ]; then
  die "must be run as root"
fi

user="${1:-${SUDO_USER:-${USER:-}}}"

if [ -z "$user" ]; then
  user="$(id -un)"
fi

# Basic username validation.
if [[ ! "$user" =~ ^[A-Za-z_][A-Za-z0-9._-]{0,31}$ ]]; then
  die "invalid username: $user"
fi

case "$user" in
  -*|*/*|*..*|*$'\n'*)
    die "invalid username: $user"
    ;;
esac

command -v passwd >/dev/null 2>&1 || die "missing command: passwd"
command -v getent >/dev/null 2>&1 || die "missing command: getent"
command -v cut    >/dev/null 2>&1 || die "missing command: cut"
command -v install >/dev/null 2>&1 || die "missing command: install"
command -v mktemp >/dev/null 2>&1 || die "missing command: mktemp"

parent="$(dirname "$DEST_DIR")"

if [ ! -d "$parent" ]; then
  die "parent directory does not exist: $parent"
fi

echo "Changing password for '$user' using standard passwd..."
passwd "$user"

line="$(getent shadow "$user")" || die "could not read shadow entry for $user"
hash="$(printf '%s\n' "$line" | cut -d: -f2)"

if [ -z "$hash" ]; then
  die "no password hash found for $user"
fi

umask 077

install -d -m 700 -o root -g root "$DEST_DIR"

tmp="$(mktemp "$DEST_DIR/.$user.XXXXXX")"
printf '%s' "$hash" > "$tmp"

chmod 600 "$tmp"
chown root:root "$tmp"

mv -f -- "$tmp" "$DEST_DIR/$user"

printf '%s: password hash for %s saved to %s\n' "$PROG" "$user" "$DEST_DIR/$user"
