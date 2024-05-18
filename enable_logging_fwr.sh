# Set the Google Cloud project ID
PROJECT_ID="akumin-shared-service-hostvpc"

# Get the list of all firewall rules in the specified project
firewall_rules=$(gcloud compute firewall-rules list --project="$PROJECT_ID" --format="value(name)")

# Loop through all firewall rules
for rule in $firewall_rules; do
  # Check if logging is already enabled for the rule
  logging_enabled=$(gcloud compute firewall-rules describe "$rule" --project="$PROJECT_ID" --format="value(logConfig.enable)")

  # If logging is not enabled, enable it
  if [[ "$logging_enabled" != "True" ]]; then
    gcloud compute firewall-rules update "$rule" --project="$PROJECT_ID" --enable-logging
    echo "Logging enabled for firewall rule: $rule"
  else
    echo "Logging is already enabled for firewall rule: $rule"
  fi
done
