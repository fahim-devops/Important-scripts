#!/bin/bash

# Define variables
BACKUP_DIR="/var/opt/gitlab/backups"
GITLAB_BACKUP_PREFIX="gitlab-backup-$(date +%Y-%m-%d-%H-%M-%S)"
GCS_BUCKET="gs://backup-gitlab-sofed-io"
GCS_BACKUP_PATH="$GCS_BUCKET/$GITLAB_BACKUP_PREFIX.tar"

# Create a backup (excluding the registry)
sudo gitlab-rake gitlab:backup:create SKIP=registry

# Verify the backup was created successfully
if [ $? -eq 0 ]; then
    echo "GitLab backup created successfully."
else
    echo "Error: GitLab backup creation failed."
    exit 1
fi

# Move the backup to the GCS bucket
sudo mv "$BACKUP_DIR/$GITLAB_BACKUP_PREFIX.tar" "/tmp/$GITLAB_BACKUP_PREFIX.tar"
gsutil cp "/tmp/$GITLAB_BACKUP_PREFIX.tar" "$GCS_BACKUP_PATH"

# Verify the backup was uploaded to GCS successfully
if [ $? -eq 0 ]; then
    echo "Backup uploaded to GCS bucket successfully."
else
    echo "Error: Failed to upload backup to GCS bucket."
    exit 1
fi

# Remove the local backup file
sudo rm "/tmp/$GITLAB_BACKUP_PREFIX.tar"

# Exit with success status
exit 0
