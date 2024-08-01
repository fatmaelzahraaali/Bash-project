Cyan='\033[1;36m'	          # Cyan Color Code
Blue='\033[1;34m'	          # Blue Color code 
Yellow='\033[1;33m'	        # Yellow Color code
RED='\033[1;31m'	          # Red Color code 
Green='\033[1;32m'	        # Green Color Green
ColorReset='\033[0m' 		    # No Color Code


############### main_menu ##########################
#this function displays the main menu with GUI 
function mainMenu(){

choice=$(zenity --list \
  --height="440"\
  --width="400"\
  --cancel-label="Exit" \
  --title="Main Menu" \
  --column="Option" \
     "1-Create Database" \
     "2-List Database" \
     "3-Connect To Database" \
     "4-Drop Database" \
     "5-Exit")

    if [ $? -eq 1 ]         #Checks if the exit status of the last command is 1
    then
         echo -e "${Green}Exited..${ColorReset}"
         exit
    fi
 
    case $choice in 
		"1") ./main_menu/create_db.sh;;
		"2") ./main_menu/list_db.sh;;
		"3") ./main_menu/connect_db.sh;;
		"4") ./main_menu/drop_db.sh;;
                "5") echo -e "${Green}Exited..${ColorReset}";
		exit;; #exit from database
		*) echo -e "${RED}invalid choice, try again ... you must choose                  only from the above list${ColorReset}";
	         mainMenu          #Call it again
	esac
}
