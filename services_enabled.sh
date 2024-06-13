#!/bin/bash

# Output CSV file
OUTPUT_CSV="enabled_services.csv"

# Header for the CSV file
echo "Project ID,Service Name" > $OUTPUT_CSV

# List all projects and filter those starting with "aku"
PROJECTS=$(gcloud projects list --format="value(projectId)" | grep '^aku')

# Check if there are any projects that match the criteria
if [ -z "$PROJECTS" ]; then
  echo "No projects found that start with 'aku'."
  exit 1
fi

# Loop through each project and list enabled services, appending to CSV file
for PROJECT in $PROJECTS; do
  SERVICES=$(gcloud services list --enabled --project="$PROJECT" --format="value(config.name)")
  for SERVICE in $SERVICES; do
    echo "$PROJECT,$SERVICE" >> $OUTPUT_CSV
  done
done

echo "CSV file $OUTPUT_CSV has been created."
