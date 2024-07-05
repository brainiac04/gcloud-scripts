from google.cloud import resource_manager

def list_folders(parent_folder=None, indent=0):
    client = resource_manager.Client()
    folders = client.list_folders(parent=parent_folder)
    
    for folder in folders:
        print('  ' * indent + folder.name)
        list_folders(parent_folder=folder, indent=indent + 1)

# Replace with your organization ID (numeric ID)
organization_id = '206683169594'

list_folders(parent_folder=f'organizations/{organization_id}')
