#!/bin/bash
DATA_DIR="/var/app/data"
mkdir -p "$DATA_DIR"

while true; do
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") - APP_EVENT - Transaction processed ID:$RANDOM" >> "$DATA_DIR/app.log"
    sleep 30
done
