#!/bin/bash

# Get the list of projects starting with "aku"
projects=$(gcloud projects list --format="value(projectId)" --filter="projectId:aku*")

# Output CSV file header
output_file="$HOME/Documents/CANADA/CAN-ME/Job/Phelix/Akumin/requests/files/stopped_instances.csv"
echo "PROJECT,INSTANCE_NAME,ZONE,MACHINE_TYPE,INSTANCE_STATUS,BOOK_DISK,BOOT_DISK_SIZE,ADDL_DISK1,ADDL_DISK1_SIZE,ADDL_DISK2,ADDL_DISK2_SIZE,ADDL_DISK3,ADDL_DISK3_SIZE,ADDL_DISK4,ADDL_DISK4_SIZE,ADDL_DISK5,ADDL_DISK5_SIZE,ADDL_DISK6,ADDL_DISK6_SIZE" > "$output_file"

# Loop through each project and check instance status
for project in $projects; do
    echo "Processing project: $project"
    
    instances=$(gcloud compute instances list --project "$project" --format="value(name)" | wc -l)
    terminated_instances=$(gcloud compute instances list --project "$project" --filter="status:TERMINATED" --format="value(name)" | wc -l)
    
    if [ $instances -eq 0 ] && [ $terminated_instances -eq 0 ]; then
        echo "$project,No instance" >> "$output_file"
    elif [ $instances -gt 0 ] && [ $terminated_instances -eq 0 ]; then
        echo "$project,Skipped" >> "$output_file"
    else
        gcloud compute instances list --project "$project"  --filter="status:TERMINATED" --format="csv(project,name,zone,MACHINE_TYPE,status,disks[0].deviceName:label=BOOT_DISK,disks[0].diskSizeGb:label=BOOT_DISK_SIZE,disks[1].deviceName:label=ADDL_DISK1,disks[1].diskSizeGb:label=ADDL_DISK1_SIZE,disks[2].deviceName:label=ADDL_DISK2,disks[2].diskSizeGb:label=ADDL_DISK2_SIZE,disks[3].deviceName:label=ADDL_DISK3,disks[3].diskSizeGb:label=ADDL_DISK3_SIZE,disks[4].deviceName:label=ADDL_DISK4,disks[4].diskSizeGb:label=ADDL_DISK4_SIZE,disks[5].deviceName:label=ADDL_DISK5,disks[5].diskSizeGb:label=ADDL_DISK5_SIZE,disks[6].deviceName:label=ADDL_DISK6,disks[6].diskSizeGb:label=ADDL_DISK6_SIZE)" | tail -n +2 | while IFS= read -r line; do >> "$output_file"
        echo "$project${line}" >> "$output_file"
        done
    fi
done
