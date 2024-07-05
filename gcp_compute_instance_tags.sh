#!/bin/bash

# Define the output CSV
OUTPUT_FILE="instance_tags.csv"

# Add a header row
echo "Project,InstanceName,Tag1,Tag2,Tag3,Tag4,Tag5" > $OUTPUT_FILE

# Get the list of projects starting with "aku"
projects=$(gcloud projects list --format="value(projectId)" --filter="name:aku*")

# Loop through each project
for project in $projects
do
    # Get the list of instances in the current project
    instances=$(gcloud compute instances list --project=$project --format="value(name)")

    # Loop through each instance in the project
    for instance in $instances
    do
        # Get the list of tags for the current instance
        tags=$(gcloud compute instances describe $instance --project=$project --format="value(tags.items)")

        # Convert tags to array and find unique tags
        IFS=',' read -ra tag_array <<< "$tags"
        unique_tags=($(echo "${tag_array[@]}" | tr ' ' '\n' | sort | uniq))

        # Add the unique tags to the CSV file
        tag_count=${#unique_tags[@]}
        if [[ $tag_count -gt 0 ]]; then
            # Write instance data to the CSV file
            echo -n "$project,$instance" >> $OUTPUT_FILE
            for tag in "${unique_tags[@]}"
            do
                echo -n ",$tag" >> $OUTPUT_FILE
            done
            # Fill any remaining columns with empty data
            remaining_columns=$((5 - tag_count))
            for ((i = 0; i < remaining_columns; i++))
            do
                echo -n "," >> $OUTPUT_FILE
            done
            echo "" >> $OUTPUT_FILE
        fi
    done
done
