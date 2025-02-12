from google.cloud import compute_v1

def list_firewall_rules(project):
    firewall_client = compute_v1.FirewallsClient()
    request = compute_v1.ListFirewallsRequest(project=project)
    
    # List all firewall rules
    firewall_rules = firewall_client.list(request=request)

    for rule in firewall_rules:
        print(f"Firewall rule name: {rule.name}")
        print(f"Hit count: {rule.log_config.enable}")

project = "your-gcp-project-id"
list_firewall_rules(project)
