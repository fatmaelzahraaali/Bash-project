#! /bin/bash

. ./functions/functions.sh


listDatabases

  if [[ $exitCode == 1 ]]
    then
        mainMenu
        exit
    fi

tableMenu $dbName
