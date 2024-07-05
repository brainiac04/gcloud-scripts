from google.cloud import logging
from google.cloud.logging import DESCENDING

def get_firewall_hit_counts(project_id):
    client = logging.Client(project=project_id)
    
    # Define the log filter for firewall rules
    filter_str = (
        'resource.type="gce_subnetwork" '
        'AND logName="projects/{}/logs/compute.googleapis.com%2Ffirewall"'
    ).format(project_id)
    
    # Query logs in batches
    hit_counts = {}

    # You can adjust the batch size as needed
    batch_size = 50
    page_token = None

    while True:
        entries = client.list_entries(
            filter_=filter_str,
            order_by=DESCENDING,
            page_token=page_token,
            page_size=batch_size
        )

        for entry in entries:
            if 'jsonPayload' in entry.payload:
                payload = entry.payload['jsonPayload']
                rule_details = payload.get('ruleDetails', {})
                rule_name = rule_details.get('ruleName', 'unknown')
                hit_count = payload.get('hitCount', 0)

                if rule_name not in hit_counts:
                    hit_counts[rule_name] = 0
                hit_counts[rule_name] += hit_count

        page_token = entries.next_page_token

        if not page_token:
            break

    return hit_counts

# Example usage
project_id = 'akumin-shared-service-hostvpc'
hit_counts = get_firewall_hit_counts(project_id)

if hit_counts:
    for rule, count in hit_counts.items():
        print(f"Firewall rule {rule} has {count} hits")
else:
    print("No firewall hit counts found or logging not enabled.")
