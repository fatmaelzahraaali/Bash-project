#! /bin/bash

. ./functions/functions.sh


askForDatabaseCred

  if [[ $exitCode == 1 ]]
    then
        mainMenu
        exit
    fi

DatabaseMenu $dbName
