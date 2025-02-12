g#!/bin/bash

# List all projects
projects=$(gcloud projects list --format="value(projectId)"  --filter="name:aku*")

# Iterate over each project and check for resources
for PROJECT in $projects; do
  echo "Checking project: $PROJECT"
  
  # Count resources in the project
  RESOURCE_COUNT=$(gcloud asset search-all-resources --scope=projects/$PROJECT --format="value(name)" | wc -l)

  if [ "$RESOURCE_COUNT" -eq "0" ]; then
    echo "Project $PROJECT has no resources."
  else
    echo "Project $PROJECT has resources."
  fi
done