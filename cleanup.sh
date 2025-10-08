#!/bin/sh
# Cleanup Azure App Service logs
rm -rf /home/LogFiles/* || true
exec "$@"#!/bin/sh
# Azure log rotation - keep latest 5 logs

LOG_DIR="/home/LogFiles"
MAX_LOGS=5

# Delete old logs beyond the latest $MAX_LOGS
if [ -d "$LOG_DIR" ]; then
    ls -tp "$LOG_DIR" | grep -v '/$' | tail -n +$((MAX_LOGS+1)) | xargs -r rm --
fi

# Run the main process
exec "$@"

