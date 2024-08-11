#!/bin/bash

# Source external functions
. ././fuctionss/functions.sh

# List tables and allow user to select one
table=$(ls -l "Database/${dbName}" | grep "^[-l]" | awk '{print $9}' | \
    zenity --list --cancel-label="Back" --height="450" --width="350" \
    --title="Tables List" --text="Select your table" --column="Table name" 2>>.errorlog)

# Check if the user cancelled the dialog
if [[ $? -eq 1 ]]; then
    DatabaseMenu "$dbName"
    exit 0
fi

# Check if a table was selected
if [[ -z "$table" ]]; then
    zenity --error --width="200" --text="No table selected."
    DatabaseMenu "$dbName"
    exit 1
fi

# Navigate to table menu with selected table
tableMenu "$dbName" "$table"

