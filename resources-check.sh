# # #!/bin/bash

# # # # Get the timestamp for 1 day ago in the format YYYY-MM-DDTHH:mm:ssZ on BSD-based systems (e.g., macOS)
# # # timestamp_one_day_ago=$(date -u -v-1d '+%Y-%m-%dT%H:%M:%SZ')

# # Function to identify problematic resources (Vertex AI, Compute Engine, BigQuery, and Cloud Functions)
# identify_problematic_resources() {
#   local project_id=$1
#   local problematic_resources=()

#   # Get the timestamp for 1 day ago in the format YYYY-MM-DDTHH:mm:ssZ
#   timestamp_one_day_ago=$(date -u -v-1d '+%Y-%m-%dT%H:%M:%SZ')

#   # Example: Identify Vertex AI models with high costs
#   vertex_ai_models=$(./google-cloud-sdk/bin/gcloud  ai models list --project="$project_id" --format=json --filter="createTime>='$timestamp_one_day_ago'")
#   high_cost_vertex_ai_models=$(echo "$vertex_ai_models" | jq -r '.[] | .name')
#   problematic_resources+=("$high_cost_vertex_ai_models")

#   # Example: Identify Compute Engine instances with high costs
#   compute_engine_instances=$(./google-cloud-sdk/bin/gcloud  compute instances list --project="$project_id" --format=json --filter="creationTimestamp>='$timestamp_one_day_ago'")
#   high_cost_compute_engine_instances=$(echo "$compute_engine_instances" | jq -r '.[] | .name')
#   problematic_resources+=("$high_cost_compute_engine_instances")

#   # You can add similar logic for other resource types (BigQuery, Cloud Functions) as needed

#   echo "${problematic_resources[@]}"
# }

# # Example usage:
# project_id="abl-occupancy-model-prod"

# # Call the identify_problematic_resources function
# problematic_resources=($(identify_problematic_resources "$project_id"))

# if [ ${#problematic_resources[@]} -gt 0 ]; then
#   # Rest of the script...
#   echo "Problematic Resources: ${problematic_resources[@]}"
# else
#   echo "No problematic resources found."
# fi




#!/bin/bash

# Function to identify problematic resources (Vertex AI, Compute Engine, BigQuery, and Cloud Functions)
identify_problematic_resources() {
  local project_id=$1
  local problematic_resources=()

  # Get the timestamp for 1 day ago in the format YYYY-MM-DDTHH:mm:ssZ
  timestamp_one_day_ago=$(date -u -v-1d '+%Y-%m-%dT%H:%M:%SZ')

  # Example: Identify Vertex AI models with high costs
  vertex_ai_models=$(gcloud ai models list --project="$project_id" --format=json --filter="createTime>='$timestamp_one_day_ago'")
  high_cost_vertex_ai_models=$(echo "$vertex_ai_models" | jq -r '.[] | .name')
  problematic_resources+=("$high_cost_vertex_ai_models")

  # Example: Identify Compute Engine instances with high costs
  compute_engine_instances=$(gcloud compute instances list --project="$project_id" --format=json --filter="creationTimestamp>='$timestamp_one_day_ago'")
  high_cost_compute_engine_instances=$(echo "$compute_engine_instances" | jq -r '.[] | .name')
  problematic_resources+=("$high_cost_compute_engine_instances")

  # You can add similar logic for other resource types (BigQuery, Cloud Functions) as needed

  echo "${problematic_resources[@]}"
}

# Function to check current billing budget
check_budget() {
  local project_id=$1
  local budget_id=$2
  local current_budget=$(gcloud beta billing budgets describe "projects/$project_id/budgets/$budget_id" --format="value(amount)")
  local cost_threshold=90  # Set your desired cost threshold in percentage

  if [ "$current_budget" -gt 0 ] && [ "$current_budget" -lt "$cost_threshold" ]; then
    echo "Current cost exceeds the budget threshold. Stopping resources..."
    # Add logic here to temporarily stop resources
    # Example: Stop all Compute Engine instances
    gcloud compute instances stop --project="$project_id" --zone=europe-west3 --quiet $(gcloud compute instances list --project="$project_id" --format="value(name)")
  else
    echo "Current cost is within the budget threshold."
  fi
}

# Example usage:
project_id="abl-occupancy-model-prod"
budget_id="budget-abl-occupancy-model-prod"
zone="europe-west3"

# Call the identify_problematic_resources function
problematic_resources=($(identify_problematic_resources "$project_id"))

if [ ${#problematic_resources[@]} -gt 0 ]; then
  # Rest of the script...
  echo "Problematic Resources: ${problematic_resources[@]}"
  # Check the budget if problematic resources are found
  check_budget "$project_id" "$budget_id"
else
  echo "No problematic resources found."
fi
