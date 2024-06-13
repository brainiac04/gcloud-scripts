#!/bin/bash

# Function to list instances and filter by name
list_instances() {
    local project=$1
    local region=$2
    local instances

    instances=$(gcloud compute instances list --project="$project" --filter="name:aku*" --format="csv(name,zone,status)")

    # Check if there are any instances
    if [[ -n "$instances" && "$instances" != "NAME,ZONE,STATUS" ]]; then
        echo "$instances" | tail -n +2 | while IFS=, read -r name zone status; do
            echo "$region,$project,$name,$zone,$status" >> /Users/velurinavya/Documents/CANADA/CAN-ME/Job/Phelix/akumin/requests/files/instances.csv
        done
    fi
}

# Create the CSV file and add the header
echo "Region,Project,Instance Name,Zone,Status" > /Users/velurinavya/Documents/CANADA/CAN-ME/Job/Phelix/akumin/requests/files/instances.csv
# List all projects
PROJECTS=$(gcloud projects list --filter="name:aku*" --format="value(projectId)")

# List all regions
REGIONS=$(gcloud compute regions list --format="value(name)")

# Loop through each project
for PROJECT in $PROJECTS; do
    # Loop through each region and list instances
    for REGION in $REGIONS; do
        # List instances in the region that start with 'aku'
        list_instances "$PROJECT" "$REGION"
    done
done

echo "Instance information has been exported to instances.csv"
