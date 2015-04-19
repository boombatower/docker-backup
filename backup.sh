#!/bin/bash
# Usage: backup.sh backup|restore [filename]
# - filename: backup.tar.xz
# Environment variables:
# - optional: TAR_OPTS

file="backup.tar.xz"
if [ $# -eq 2 ]; then 
  file="$2"
fi
file="/backup/$file"

if [ "$1" = "backup" ]; then
  # Skip the three host configuration entries always setup by Docker and 4th which is /backup provided by this image.
  volumes=$(cat /proc/mounts | \
            grep -oP "/dev/[^ ]+ \K(/[^ ]+)" | \
            grep -v "/backup" | \
            grep -v "/etc/resolv.conf" | \
            grep -v "/etc/hostname" | \
            grep -v "/etc/hosts" | \
            tr '\n' ' ')

  if [ -z "$volumes" ]; then
    echo "No volumes were detected."
    exit 1
  fi

  echo "Volumes detected: $volumes"
  echo "Creating archive..."

  tar --create --recursion --xz $TAR_OPTS \
    --file "$file" \
    --one-file-system \
    $volumes

  echo "Written to $file"
elif [ "$1" = "restore" ]; then
  echo "Restoring from $file"

  tar --extract --preserve-permissions $TAR_OPTS \
    --file "$file" \
    -C /
fi
