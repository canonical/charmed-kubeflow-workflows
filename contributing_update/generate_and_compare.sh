#!/bin/bash

# Read the directory path from the first argument
DIR_PATH="$1"

# Define the path to the template file relative to DIR_PATH
TEMPLATE_FILE="$DIR_PATH/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="contributing_inputs.toml"

# Create a new file called contributing.md in the specified directory
OUTPUT_FILE="$DIR_PATH/contributing.md"

# Read the template file contents
template=$(cat "$TEMPLATE_FILE")

# Read the values from the inputs file (TOML) and replace placeholders in the template
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*([^=[:space:]]+)[[:space:]]*=[[:space:]]*\"([^\"]*)\" ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"
    echo "Replacing $key with $value"
    template=${template//\{\{[[:space:]]*$key[[:space:]]*\}\}/$value}
  fi
done < "$INPUTS_FILE"

# Write the modified template to the output file
echo "$template" > "$OUTPUT_FILE"

echo -e "Generated contributing file from template. Contents: \n"
cat "$OUTPUT_FILE"