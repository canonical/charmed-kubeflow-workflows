#!/bin/bash

# Read the temp path from the first argument
TEMP_PATH="$1"

# Read the charm path from the second argument
CHARM_PATH="$2"

# Define the path to the template file relative to TEMP_PATH
TEMPLATE_FILE="$TEMP_PATH/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="$CHARM_PATH/contributing_inputs.yaml"

# Create a new file called contributing.md in the specified directory
OUTPUT_FILE="$TEMP_PATH/contributing.md"

# Read the template file contents
template=$(cat "$TEMPLATE_FILE")

# Use yq to get the list of keys from the inputs file
keys=$(yq eval 'keys | .[]' "$INPUTS_FILE")

# Section placeholders are special, and will get two newlines prepended to them if non-empty
section_placeholders=("charm_specific_text")

# Function to check if an element is present in an array
containsElement () {
  local element
  for element in "${@:2}"; do [[ "$element" == "$1" ]] && return 0; done
  return 1
}

# Iterate over the keys and extract the values using yq
for key in $keys; do
  value=$(yq eval ".$key" "$INPUTS_FILE")

  # If the key is in section_placeholders array and the value non-empty, prepend two newlines
  if containsElement "$key" "${section_placeholders[@]}" && [ ! -z "$value" ]; then
      value="\n\n${value}"
  fi

  echo "Replacing $key with $value"
  template=$(awk -v key="$key" -v value="$value" '{ gsub("{{[[:space:]]*" key "[[:space:]]*}}", value) }1' <<< "$template")
done

# Write the modified template to the output file
echo "$template" > "$OUTPUT_FILE"

echo "Generated contributing file from template."

# Check if there are any remaining {{ }} expressions in the generated template
remaining_expr=$(grep -o '{{[^}]*}}' <<< "$template")

if [ -n "$remaining_expr" ]; then
  echo "Error: Some {{ }} expressions are still present in the generated template:"
  echo "$remaining_expr"
  exit 1
fi

# Check if contributing.md already exists in the charm path
if [ -f "$CHARM_PATH/contributing.md" ]; then
  existingContributingContents=$(cat "$CHARM_PATH/contributing.md")
  echo "Existing contributing file found with contents: $existingContributingContents"
else
  # If the file is not found, we treat it the same as a file with empty contents
  existingContributingContents=""
  echo "No existing contributing file found"
fi

# Compare the substituted template with the existing contributing contents
if [ "$template" = "$existingContributingContents" ]; then
  echo "Contributing file is up to date. No need for a PR."
  echo "comparison_result=0" >> $GITHUB_ENV
else
  echo "comparison_result=1" >> $GITHUB_ENV
fi

echo "updated_contributing_contents=$template" >> $GITHUB_ENV