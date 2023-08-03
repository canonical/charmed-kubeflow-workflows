#!/bin/bash

# Read the temp path from the first argument
TEMP_PATH="$1"

# Read the charm path from the second argument
CHARM_PATH="$2"

# Define the path to the template file relative to TEMP_PATH
TEMPLATE_FILE="$TEMP_PATH/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="contributing_inputs.yaml"

# Create a new file called contributing.md in the specified directory
OUTPUT_FILE="$TEMP_PATH/contributing.md"

# Check if contributing.md already exists in the charm path
if [ -f "$CHARM_PATH/contributing.md" ]; then
  existingContributingContents=$(cat "$CHARM_PATH/contributing.md")
else
  echo "Error: contributing.md not found in the charm path: $CHARM_PATH"
  echo "Current working directory: $(pwd)"
  echo "Files in current working directory: "
  ls
  exit 1
fi

# Read the template file contents
template=$(cat "$TEMPLATE_FILE")

# Use yq to get the list of keys from the inputs file
keys=$(yq eval 'keys | .[]' "$INPUTS_FILE")

# Iterate over the keys and extract the values using yq
for key in $keys; do
  value=$(yq eval ".$key" "$INPUTS_FILE")
  echo "Replacing $key with $value"
  template=$(awk -v key="$key" -v value="$value" '{ gsub("{{[[:space:]]*" key "[[:space:]]*}}", value) }1' <<< "$template")
done

# Write the modified template to the output file
echo "$template" > "$OUTPUT_FILE"

echo -e "Generated contributing file from template. Contents: \n"
cat "$OUTPUT_FILE"

# Check if there are any remaining {{ }} expressions in the generated template
remaining_expr=$(grep -o '{{[^}]*}}' <<< "$template")

if [ -n "$remaining_expr" ]; then
  echo "Error: Some {{ }} expressions are still present in the generated template:"
  echo "$remaining_expr"
  exit 1
fi

# Compare the substituted template with the existing contributing contents
if [ "$template" = "$existingContributingContents" ]; then
  echo "Contributing file is up to date. No need for a PR."
  echo "comparison_result=0" >> $GITHUB_ENV
else
  echo "comparison_result=1" >> $GITHUB_ENV
fi

echo "updated_contributing_contents=$template" >> $GITHUB_ENV