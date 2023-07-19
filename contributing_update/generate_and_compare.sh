#!/bin/bash

# Get the directory containing the script
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Define the path to the template file relative to SCRIPT_DIR
TEMPLATE_FILE="$CONTRIBUTING_UPDATE_DIR/contributing.md.template"

# Define the path to the inputs file relative to the current working directory
INPUTS_FILE="contributing_inputs.toml"

# Read and display the contents of the template file
if [[ -f "$TEMPLATE_FILE" ]]; then
    echo "Template file contents:"
    cat "$TEMPLATE_FILE"
else
    echo "Template file does not exist: $TEMPLATE_FILE"
fi

# Read and display the contents of the inputs file if it exists in the current working directory
if [[ -f "$INPUTS_FILE" ]]; then
    echo "Inputs file contents:"
    cat "$INPUTS_FILE"
else
    echo "Inputs file does not exist: $INPUTS_FILE"
fi