#!/bin/bash

Cyan='\033[1;36m'	          # Cyan Color Code
Blue='\033[1;34m'	          # Blue Color code 
Yellow='\033[1;33m'	        # Yellow Color code
RED='\033[1;31m'	          # Red Color code 
Green='\033[1;32m'	        # Green Color Green
ColorReset='\033[0m' 		    # No Color Code

### main_menu ###

### this function displays the main menu with GUI ### 

mainMenu()
{
     choice=$(zenity --list \
         --height="400"\
         --width="400"\
         --cancel-label="Exit" \
         --title="Main Menu" \
         --column="Option" \
         "Create Database" \
         "List Database" \
         "Connect To Database" \
         "Drop Database" \
         "Exit")

     if [ $? -eq 1 ]         #Checks if the exit status of the last command is 1
     then
          echo -e "${Green}Exited..${ColorReset}"
          exit
     fi
 
     case $choice in 
		"Create Database") ./options/create_db.sh;;
		"List Database") ./options/list_db.sh;;
		"Connect To Database") ./options/connect_db.sh;;
		"Drop Database") ./options/drop_db.sh;;
                "Exit") echo -e "${Green}Exited..${ColorReset}";
		exit;; #exit from database
		*) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}";

        	mainMenu          #Call it again
       esac
}


### this function checks if the database already exist or not ####

isDatabaseExist()
{
  if [ -d ./Database/$1 ]
  then
	  return 0          #returns  0 if true (exist)
  else
	  return 1          #returns 1 if false (not exist)
  fi

}
### this function creates database ####

createDatabase()
{

  mkdir ./Database/$1
  mkdir ./Database/$1/.metadata

}
