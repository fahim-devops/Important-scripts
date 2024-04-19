#!/bin/bash

# Fetching all CodePipeline pipeline names in us-east-2 region
pipelines=$(aws codepipeline list-pipelines --region us-east-2 --profile tenforty-eks --query "pipelines[*].name" --output text)

# Check if there are any pipelines
if [ -z "$pipelines" ]; then
    echo "No pipelines found in us-east-2 region."
    exit 0
fi

# Loop through each pipeline and delete it
for pipeline in $pipelines; do
    echo "Deleting pipeline: $pipeline"
    aws codepipeline delete-pipeline --name "$pipeline" --region us-east-2 --profile tenforty-eks
    echo "Pipeline $pipeline deleted."
done

echo "All pipelines in us-east-2 region have been deleted."
