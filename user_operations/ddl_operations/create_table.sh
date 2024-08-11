#!/bin/bash


. ././functions/functions.sh

# Display zenity menu
create=$(zenity --list \
  --height="250" \
  --width="350" \
  --cancel-label="Back" \
  --title="Create Table" \
  --column="Option" \
     "create table" \
     "Exit")

# Check if the user pressed "Cancel" or closed the dialog
if [ $? -eq 1 ]; then
     DatabaseMenu $dbName
fi

# Handle user selection
case $create in
    "create table")
        table
        ;;
    "Exit")
        zenity --question --text="Are you sure you want to exit?" --width="250"
        if [ $? -eq 0 ];
       	then
            exit
        else
            $0 # Restart the script if the user cancels the exit
        fi
        ;;
    *)
        zenity --error --text="Invalid choice, try again." --width="250"
        $0 # Restart the script in case of an invalid choice
        ;;
esac

