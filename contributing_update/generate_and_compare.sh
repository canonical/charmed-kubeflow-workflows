#!/bin/bash

# Read the directory path from the first argument
DIR_PATH="$1"

# Define the path to the template file relative to DIR_PATH
TEMPLATE_FILE="$DIR_PATH/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="contributing_inputs.yaml"

# Create a new file called contributing.md in the specified directory
OUTPUT_FILE="$DIR_PATH/contributing.md"

# Read the template file contents
template=$(cat "$TEMPLATE_FILE")

# Use yq to get the list of keys from the inputs file
keys=$(yq eval 'keys | .[]' "$INPUTS_FILE")

# Iterate over the keys and extract the values using yq
for key in $keys; do
  value=$(yq eval ".$key" "$INPUTS_FILE")
  echo "Replacing $key with $value"
  template=${template//\{\{[[:space:]]*$key[[:space:]]*\}\}/"$value"}
done

# Write the modified template to the output file
echo "$template" > "$OUTPUT_FILE"

echo -e "Generated contributing file from template. Contents: \n"
cat "$OUTPUT_FILE"