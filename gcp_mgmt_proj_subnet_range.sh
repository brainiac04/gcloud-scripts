#!/bin/bash

# Subnet name to search for
SUBNET_NAME="aku-shs-np-svpc-use4-10-210-10-0-26"

# Get list of all projects that start with "aku"
PROJECTS=$(gcloud projects list --filter="name:aku*" --format="value(projectId)")

# Iterate over each project
for PROJECT in $PROJECTS; do
    echo "Checking project: $PROJECT"

    # List all instances in the project without setting the project
    INSTANCES=$(gcloud compute instances list --project=$PROJECT --format="csv[no-heading](name,networkInterfaces.subnetwork)")

    # Check if instances CSV is not empty
    if [ -n "$INSTANCES" ]; then
        # Check if any instance has the subnet name
        echo "$INSTANCES" | while IFS=, read -r INSTANCE_NAME SUBNETWORK; do
            echo "Instance: $INSTANCE_NAME, Subnetwork: $SUBNETWORK"
            if [[ "$SUBNETWORK" == *"$SUBNET_NAME"* ]]; then
                echo "Project: $PROJECT contains an instance with subnet: $SUBNET_NAME"
                # Exit the loop once the subnet is found in the project
                break 2
            fi
        done
    else
        echo "No instances found in project: $PROJECT"
    fi
done
