#!/bin/bash
# Usage: s3.sh backup|restore [filename]
# - filename: backup.tar.xz
# Environment variables:
# - required: ACCESS_KEY, SECRET_KEY, and BUCKET
# - optional: S3CMD_OPTS

if [ -z "$ACCESS_KEY" -o -z "$SECRET_KEY" -o -z $BUCKET ]
then
  echo "ACCESS_KEY, SECRET_KEY, and BUCKET environment variables are required"
  exit 1
fi

file="backup.tar.xz"
if [ $# -eq 2 ]; then 
  file="$2"
fi

if [ "$1" = "backup" ]; then
  /root/bin/backup.sh backup "$file"
  s3cmd --access_key="$ACCESS_KEY" --secret_key="$SECRET_KEY" \
    -c /dev/null $S3CMD_OPTS put "/backup/$file" $BUCKET
elif [ "$1" = "restore" ]; then
  s3cmd --access_key="$ACCESS_KEY" --secret_key="$SECRET_KEY" \
    -c /dev/null $S3CMD_OPTS get "$BUCKET$file" "/backup/$file"
  /root/bin/backup.sh restore "$file"
fi
