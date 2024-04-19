#!/bin/bash

# Fetching all ECR repository names in us-east-2 region
repositories=$(aws ecr describe-repositories --region us-east-2 --profile tenforty-eks --query "repositories[*].repositoryName" --output text)

# Check if there are any repositories
if [ -z "$repositories" ]; then
    echo "No ECR repositories found in us-east-2 region."
    exit 0
fi

# Loop through each repository and delete it
for repository in $repositories; do
    echo "Deleting repository: $repository"
    aws ecr delete-repository --repository-name "$repository" --force --region us-east-2 --profile tenforty-eks
    echo "Repository $repository deleted."
done

echo "All ECR repositories in us-east-2 region have been deleted."