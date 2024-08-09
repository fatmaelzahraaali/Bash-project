#!/bin/bash


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
		"Create Database") ./mainMenu_options/create_db.sh;;
		"List Database") ./mainMenu_options/list_db.sh;;
		"Connect To Database") ./mainMenu_options/connect_db.sh;;
		"Drop Database") ./mainMenu_options/drop_db.sh;;
                "Exit") echo -e "${Green}Exited..${ColorReset}";
		exit;; #exit from database
		*) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}";

        	mainMenu          #Call it again
       esac
}

############################### creating db functions #########################
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

askForDatabaseCred() 
{
    # Check if DBMS is installed
    installed=$(printenv DBMS_INSTALLED)
    dbUser=$(printenv DB_USER)
    dbPass=$(printenv DB_PASS)
    
    if [[ -z "$installed" ]];
    then
        zenity --error --width="230" --text="Database Management System is not installed."
        exit 1
    fi

    while true;
    do
        # Prompt user for database credentials
        data=$(zenity --forms --title="Database login" \
            --cancel-label="Exit" \
            --text="Enter your database credentials." \
            --separator="," \
            --add-entry="Database username" \
            --add-password="Database password")
        
        dbUsername=$(echo $data | cut -d "," -f 1)
        dbPassword=$(echo $data | cut -d "," -f 2)
        
        # Validate credentials
        if [[ $dbUsername == $dbUser ]] && [[ $dbPassword == $dbPass ]];
       	then
            break
        else
            zenity --error --width="230" --text="Database credentials are incorrect"
        fi
    done

    while true;
    do
        # List available databases and prompt user to select one
        dbName=$(ls -l Database | grep "^d" | awk '{print $9}' | zenity --cancel-label="Back" --list --height="250" --width="300" --title="Database List" --text="Select your database" --column="Database name")
        
        lastOp=$?
        if [[ $lastOp == 1 ]];
       	then
            mainMenu
            return
        fi
        
        if [[ -z "$dbName" ]];
       	then
            zenity --error --width="230" --text="Database field cannot be empty"
        else
            if isDatabaseExist "$dbName"; then
                break
            else
                zenity --error --width="200" --text="Database [$dbName] does not exist"
            fi
        fi
    done
}


DatabaseMenu(){
  choice=$(zenity --list \
  --height="250"\
  --width="350"\
  --cancel-label="Back" \
  --title="Database $1 Menu" \
  --column="Option" \
     "Create Table" \
     "List Tables" \
     "Main Menu" \
     "Exit")

        if [ $? -eq 1 ]
        then
            mainMenu
        fi

    case $choice in
            "Create Table"). ./user_operations/ddl_operations/create_table.sh $1;;
            "List Tables" ). ./user_operations/ddl_operations/list_tables.sh $1;;
            "Main Menu") mainMenu;;
            "Exit") echo -e "${Green}Exited..${ColorReset}";exit;; #exit from database
            *) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}";mainMenu #Call it again
    esac
}
