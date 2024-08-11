#! /bin/bash

# using sourcing
. ././functions/functions.sh



  choice=$(zenity --list \
  --height="250"\
  --width="350"\
  --cancel-label="Back" \
  --title="Table $table Menu" \
  --column="Option" \
     "Select All From $table" \
     "Select All By Column From $table" \
     "Select By Column From $table" \
     "Main Menu" \
     "Exit")

        if [ $? -eq 1 ]
        then
            tableMenu $dbName $table
        fi

case $choice in 
    "Select All From $table"). ./user_operations/dml-operations/select_statments/select_all_from_table.sh $dbName $table;;
    "Select All By Column From $table"). ./user_operations/dml-operations/select_statments/select_all_from_table_by_column.sh $dbName $table;;
    "Select By Column From $table"). ./user_operations/dml-operations/select_statments/select_by_key_from_table.sh $dbName $table;;
    "Main Menu") mainMenu;;
    "Exit") echo -e "${Green}Exited..${ColorReset}";exit;; #exit from database
    *) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}";mainMenu #Call it again
esac 
