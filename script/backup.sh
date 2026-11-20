#!/bin/bash
SOURCE_DIR="/var/app/data"
BUCKET="caleb-backup-project-2026"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H%M")
ARCHIVE="/tmp/backup-${TIMESTAMP}.tar.gz"
LOG_FILE="/var/log/backup.log"

tar -czf "$ARCHIVE" -C "$SOURCE_DIR" .

if aws s3 cp "$ARCHIVE" "s3://${BUCKET}/backups/backup-${TIMESTAMP}.tar.gz"; then
    echo "$(date -u): SUCCESS - Uploaded backup-${TIMESTAMP}.tar.gz" >> "$LOG_FILE"
    rm -f "$ARCHIVE"
else
    echo "$(date -u): ERROR - Failed to upload backup-${TIMESTAMP}.tar.gz" >> "$LOG_FILE"
    exit 1
fi
