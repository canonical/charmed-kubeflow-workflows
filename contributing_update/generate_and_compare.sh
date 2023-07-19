#!/bin/bash

# Read the directory path from the first argument
DIR_PATH="$1"

# Define the path to the template file relative to DIR_PATH
TEMPLATE_FILE="$DIR_PATH/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="contributing_inputs.toml"

# Create a new file called contributing.md in the specified directory
OUTPUT_FILE="$DIR_PATH/contributing.md"

# Read the values from the inputs file (TOML)
eval "$(grep -E "^\w+=" "$INPUTS_FILE" | sed 's/=/="/; s/$/"/')"

# Read the template file contents
template=$(cat "$TEMPLATE_FILE")

# Replace placeholders in the template with corresponding values from TOML
for key in $(grep -E "^\w+=" "$INPUTS_FILE" | cut -d'=' -f1); do
  template=${template//\{\{$key\}\}/${!key}}
done

# Write the modified template to the output file
echo "$template" > "$OUTPUT_FILE"

echo "Generated contributing file from template. Contents: \n\n"
cat "$OUTPUT_FILE"