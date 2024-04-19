#!/bin/bash

# Fetch all GCS bucket names
buckets=$(gsutil ls)

# Iterate through each bucket and fetch lifecycle rules
for bucket in $buckets; do
    echo "Fetching lifecycle rules for bucket: $bucket"
    
    # Fetch and display lifecycle rules
    gsutil lifecycle get $bucket
    
    # Add a separator for better visibility
    echo "----------------------------------------"
done
# #!/bin/bash

# buckets=$(gsutil ls)

# # Print header
# echo "Sr No | Bucket Name | Type | Condition"

# # Iterate over each bucket
# count=1
# for bucket in $buckets; do
#     # Fetch the lifecycle rules for the current bucket
#     lifecycle_rules=$(gsutil lifecycle get $bucket 2>/dev/null)

#     # Extract and format the information using sed
#     bucket_name=$(basename $bucket)
#     if [ -z "$lifecycle_rules" ]; then
#         echo "$count | $bucket_name | No Lifecycle Rules | -"
#     else
#         type=$(echo "$lifecycle_rules" | sed -n 's/.*<Type>\(.*\)<\/Type>.*/\1/p')
#         condition=$(echo "$lifecycle_rules" | sed -n 's/.*<Age>\(.*\)<\/Age>.*/\1/p')
#         echo "$count | $bucket_name | $type | $condition"
#     fi

#     ((count++))
# done