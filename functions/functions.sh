#!/bin/bash

RED='\033[1;31m'	          # Red Color code 
Green='\033[1;32m'	        # Green Color Green
ColorReset='\033[0m' 		    # No Color Code

### main_menu ###

### this function displays the main menu with GUI ### 

mainMenu()
{
     choice=$(zenity --list \
         --height="450"\
         --width="400"\
         --cancel-label="Exit" \
         --title="Main Menu" \
         --column="Option" \
         "Create Database" \
         "List Database" \
         "Connect To Database" \
         "Drop Database")

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

listDatabases() 
{
    

    while true;
    do
        # List available databases and prompt user to select one
        dbName=$(ls -l Database | grep "^d" | awk '{print $9}' | zenity --cancel-label="Back" --list --height="450" --width="400" --title="Database List" --text="Select your database" --column="Database name")
        
        
        if [ $? -eq 1 ] || [$? -eq 0];
       	then
            mainMenu
            return
        fi
        if [ -z "$dbName" ]
       	then
            zenity --error --width="230" --text="Database field cannot be empty"
        else
            if isDatabaseExist "$dbName";
	    then
                break
            else
                zenity --error --width="200" --text="Database [$dbName] does not exist"
            fi
        fi
    done
}

tableMenu()
{

  choice=$(zenity --list \
  --height="450"\
  --width="400"\
  --cancel-label="Back" \
  --title="Table $2 Menu" \
  --column="Option" \
     "create Table [$2]" \
     "Drop Table [$2]" \
     "list Tables [$2]" \
     "Insert into Table [$2]" \
     "Select From Table [$2]" \
     "Delete From Table [$2]" \
     "Update Table [$2]" \
     "Main Menu" \
     "Exit")

        if [ $? -eq 1 ]
        then
            mainMenu 
        fi

case $choice in
    "create Table [$2]"). ./user_operations/ddl_operations/create_table.sh $1 $2;;
    "list Tables [$2]"). ./user_operations/ddl_operations/list_tables.sh $1 $2;;
    "Drop Table [$2]"). ./user_operations/ddl_operations/drop_table.sh $1 $2;;
    "Insert Into Table [$2]"). ./user_operations/dml_operations/insert_into_table.sh $1 $2;;
    "Select From Table [$2]"). ./user_operations/dml_operations/select_menu.sh $1 $2;;
    "Delete From Table [$2]"). ./user_operations/dml_operations/delete_menu.sh $1 $2;;
    "Update Table [$2]"). ./user_operations/dml_operations/update_table_by_column.sh $1 $2;;
    "Main Menu") mainMenu;;
    "Exit") echo -e "${Green}Exited..${ColorReset}";exit;; #exit from database
    *) echo -e "${RED}invalid choice, try again ... you must choose only from the above list${ColorReset}"; mainMenu          #Call it again
esac

}

createColumns(){
while true;
do
      column=$(zenity --entry \
      --title="Enter the number of columns" \
      --cancel-label="Back" \
      --text="Enter the number of columns:" \
      --entry-text "number-column")
	
      if [ $? -eq 1 ]
      then 
	   tableMenu $dbName
	   return
      fi 

      if [[ $column =~ ^[0-9]+$ ]];
      then
     
        for (( i = 1 ; i <= $column ; i++ ));
        do
           while true;
             do
              tablename=$(zenity --entry \
              --title="Enter column name" \
              --cancel-label="Back" \
              --text="Enter column name:" \
              --entry-text "Column-name")
         
           	if [[ $? -eq 1 ]];
	       	then
                  tableMenu $dbName
                  return
                fi
                if [[ -z "$tablename" ]] || [[ ! $tablename =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] 
                then
                  zenity --error --width="300" --text="column field cannot be empty or start with space or number or special char"
                else
                    break
                fi
        done
        tablekind=$(zenity --list \
         --height="350"\
         --width="250"\
         --cancel-label="Exit" \
         --title="$tablename Kind" \
         --column="Option" \
            "Integer" \
            "String" )

         if (( $i == $column ));
          then
              echo -e "$tablename;$tablekind" >> $2
              zenity --info --width="200" --text="[$tablename] created succefully"
              mainMenu
        elif (( $i < $column ));
          then
              echo -e "$tablename;$tablekind" >> $2 
          fi
      done
    else
          zenity --error --width="300" --text="column number cannot be empty or start with space or number or special char"
      fi
  done
}

createtable()
{
    touch Database/$dbName/$1
    touch Database/$dbName/.metadata/$1.meta
    createColumns Database/$dbName/$1 Database/$dbName/.metadata/$1.meta
}

isTableExist()
{
  if [ -f ./Database/$dbName/$1 ]
  then
    # 0 = true
    return 0 
  else
    # 1 = false
    return 1
  fi
  
}

#creates a table
table()
{
 while true
 do
  tablename=$(zenity --entry \
    --title="Add new table" \
    --cancel-label="Back" \
    --text="Enter table name:" \
    --entry-text "table-name")
   if [ $? -eq 1]
   then
      tableMenu $dbName
   fi   

  if [[ -z "$tablename" ]] || [[ ! $tablename =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
  then
      zenity --error --width="300" --text="Table field cannot be empty or start with space or number or special char"
  else
      # check if the Table is exit or not
      if isTableExist $tablename
      then
          zenity --error --width="200" --text="[$tablename] is already exist"
      else
          createtable $tablename

          # check if last command is Done
          if [ $? -eq 0 ]
          then
              
              zenity --info --width="200" --text="[$tablename] created succefully"
              break
          else
            
              zenity --error --width="200" --text="Error occured during creating the table"

          fi

        fi
      fi
done
}

