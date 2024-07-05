# Get current date and time in UTC

CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Calculate the date 6 weeks ago
SIX_WEEKS_AGO=$(date -u -v -6w +"%Y-%m-%dT%H:%M:%SZ")

# Combine the commands with updated timestamps
gcloud alpha logging read "timestamp>='$SIX_WEEKS_AGO' AND timestamp<='$CURRENT_DATE' AND resource.type=gce_firewall_rule AND protoPayload.resourceName=projects/akumin-shared-service-hostvpc/global/firewalls/allow-ingress-modlink-prod"
