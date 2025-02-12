#!/bin/bash

# Set variables
PROJECT_ID="weighty-volt-205620"
INSTANCE_NAME="phelix-prod-microservices-backup"

# Fetch all backup IDs
BACKUP_IDS=$(gcloud sql backups list --instance="$INSTANCE_NAME" --project="$PROJECT_ID" --format="value(id)")

TOTAL_BYTES=0

# Loop through each backup ID and get maxChargeableBytes
for BACKUP_ID in $BACKUP_IDS; do
    BYTES=$(gcloud sql backups describe "$BACKUP_ID" --instance="$INSTANCE_NAME" --project="$PROJECT_ID" --format="value(maxChargeableBytes)")
    
    # Ensure BYTES is not empty before adding
    if [[ ! -z "$BYTES" ]]; then
        TOTAL_BYTES=$((TOTAL_BYTES + BYTES))
    fi
done

# Convert to GB
TOTAL_GB=$(echo "scale=4; $TOTAL_BYTES / (1024*1024*1024)" | bc)

# Print result
echo "Total estimated backup storage: $TOTAL_GB GB"