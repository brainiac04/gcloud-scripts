#!/bin/bash

# Define the output CSV file
OUTPUT_FILE="netapp_volumes.csv"

# Write the CSV header to the output file
echo "project_id,name,LOCATION,storage_pool,capacity_gib,used_gib,service_level,share_name,state" > $OUTPUT_FILE

# Get the list of all projects
projects=$(gcloud projects list --filter="project_id:aku*" --format="value(project_id)")

# Iterate through each project
for project in $projects; do
    echo "Processing project: $project"
    
    # Check if NetApp API is enabled
    service_enabled=$(gcloud services list --project $project --enabled --filter="config.name:netapp.googleapis.com" --format="value(config.name)")
    
    if [[ "$service_enabled" == "netapp.googleapis.com" ]]; then
        echo "NetApp API is enabled for project: $project"
        
        # List NetApp volumes and append to the CSV file
        gcloud netapp volumes list --project $project --format="csv(name,LOCATION,storage_pool,capacity_gib,used_gib,service_level,share_name,state)" \
        | tail -n +2 | while IFS=, read -r name LOCATION storage_pool capacity_gib used_gib service_level share_name state; do
            echo "$project,$name,$LOCATION,$storage_pool,$capacity_gib,$used_gib,$service_level,$share_name,$state" >> $OUTPUT_FILE
        done
    else
        echo "NetApp API is not enabled for project: $project. Skipping..."
    fi
done

echo "CSV export completed: $OUTPUT_FILE"
