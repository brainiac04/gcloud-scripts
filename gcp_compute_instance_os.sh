#!/bin/bash

# Define the output CSV file
OUTPUT_FILE="compute_instances_os_info.csv"

# Print the CSV header
echo "Project ID,Instance Name,Zone,OS" > $OUTPUT_FILE

# Get the list of projects starting with 'aku'
PROJECTS=$(gcloud projects list --filter="name:aku*" --format="value(projectId)")

for PROJECT in $PROJECTS; do
    echo "Processing project: $PROJECT"

    # Get the list of compute instances for each project
    INSTANCES=$(gcloud compute instances list --project=$PROJECT --format="csv(name,zone)")

    # Skip the header line
    INSTANCES=$(echo "$INSTANCES" | tail -n +2)

    for INSTANCE in $INSTANCES; do
        INSTANCE_NAME=$(echo $INSTANCE | cut -d',' -f1)
        ZONE=$(echo $INSTANCE | cut -d',' -f2)

        # Get the OS information of the instance
        OS_INFO=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --project=$PROJECT --format="get(disks[0].licenses)")

        # Clean the OS information
        OS=$(echo $OS_INFO | awk -F'/' '{print $NF}')

        # Append the information to the CSV file
        echo "$PROJECT,$INSTANCE_NAME,$ZONE,$OS" >> $OUTPUT_FILE
    done
done

echo "CSV file with compute instances OS information has been created: $OUTPUT_FILE"
