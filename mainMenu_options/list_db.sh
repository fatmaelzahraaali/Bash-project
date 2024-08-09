#! /bin/bash
. ./functions/functions.sh


#listing the databases

DIR=Database
if [ -z "$(ls -A $DIR)" ];
then
    zenity --error --width="200" --text="No Database found"
    mainMenu
else
    dbName="$(ls -l Database | grep "^d" | awk -F ' ' '{print $9}' | zenity --list --height="400" --width="400" --title="Databasees in system" --cancel-label="back"  --column="list:" 2>>.errorlog)"
fi

if [ $? -eq 1 ]
then
      mainMenu
fi

