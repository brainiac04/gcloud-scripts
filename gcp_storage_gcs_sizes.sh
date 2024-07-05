#!/bin/bash

# Initialize total size variable
total_size=0

# Get list of project IDs
PROJECT_IDS=$(gcloud projects list --format="value(projectId)"  --filter="name:aku*")

for PROJECT_ID in $PROJECT_IDS; do
    echo "Processing project: $PROJECT_ID"
    # Get the list of buckets in the project
    BUCKETS=$(gsutil ls -p $PROJECT_ID)
    
    for BUCKET in $BUCKETS; do
        echo "Processing bucket: $BUCKET"
        # Get the total size of the bucket in bytes
        BUCKET_SIZE=$(gsutil du -s $BUCKET | awk '{print $1}')
        # Add the bucket size to the total size
        total_size=$((total_size + BUCKET_SIZE))
    done
done

# Convert total size to human-readable format
total_size_hr=$(numfmt --to=iec-i --suffix=B $total_size)
echo "Total combined GCS size across all projects: $total_size_hr"
