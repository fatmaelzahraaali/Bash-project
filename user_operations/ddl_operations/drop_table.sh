#!/bin/bash

. ././functions/functions.sh


# Confirm deletion with the user
zenity --question --width="300" --text="Are you sure you want to delete the table '${table}' from database '${dbName}'?"
if [[ $? -eq 0 ]];
then
    # Attempt to remove the table
    rm -r "Database/${dbName}/${table}"

    if [[ $? -eq 0 ]];
    then
        zenity --notification --width="200" --text="${table} Deleted Successfully"
    else
        zenity --error --width="200" --text="Failed to delete ${table}. Please check if the table exists."
    fi
fi

# Return to main menu
mainMenu
