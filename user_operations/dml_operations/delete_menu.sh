#! /bin/bash

# using sourcing
. ././functions/functions.sh



  choice=$(zenity --list \
  --height="250"\
  --width="350"\
  --cancel-label="Back" \
  --title="Table $table Menu" \
  --column="Option" \
     "Delete All From $table" \
     "Main Menu" \
     "Exit")

        if [ $? -eq 1 ]
        then
            tableMenu $dbName $table
        fi

case $choice in 
    "Delete All From $table"). ./user_operations/dml-operations/delete_statments/delete_all_from_table.sh $dbName $table;;
    "Main Menu") mainMenu;;
    "Exit") echo -e "${Green}Exited..${ColorReset}";exit;; #exit from database
    *) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}";mainMenu #Call it again
esac 
