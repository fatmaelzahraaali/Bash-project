#! /bin/bash

# using sourcing
. ././functions/functions.sh


column="$(awk "NR>0" Database/$dbName/.metadata/$table.meta | awk -F ';' '{print $1}' | zenity --list --height="250" --width="300" --title="Table $table Columns" --text="Select Your Choosen Column"  --column="Columns" 2>>.errorlog)"

column_index=$(grep -n "$column" Database/$dbName/.metadata/$table.meta | cut -d ':' -f1)

column_type=$(grep -n "$column" Database/$dbName/.metadata/$table.meta | cut -d ':' -f2 | cut -d ';' -f2)


while true
do
    old_column_value=$(zenity --entry \
    --title="Enter The key $column Value" \
    --text="Update $table set $column =  " \
    --width="200" \
    --entry-text "")


        if [[ -z "$old_column_value" ]]
        then 
            zenity --error --width="300" --text="Column [$column] field cannot be empty"
        else
        
            if [[ $column_type == "Integer" ]]
            then
                if [[ $old_column_value =~ ^[0-9]+$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts integers only"
                fi
            fi

            if [[ $old_column_value == "String" ]]
            then
                if [[ $old_column_value =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts string only"
                fi
            fi
        fi
    
done

while true
do
    new_column_value=$(zenity --entry \
    --title="Enter The $column Value" \
    --text="Update $table set $column = {ِVALUE} where $column = $old_column_value " \
    --width="200" \
    --entry-text "")

        if [[ -z "$new_column_value" ]]
        then 
            zenity --error --width="300" --text="Column [$column] field cannot be empty"
        else
        
            if [[ $column_type == "Integer" ]]
            then
                if [[ $new_column_value =~ ^[0-9]+$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts integers only"
                fi
            fi

            if [[ $column_type == "String" ]]
            then
                if [[ $new_column_value =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts string only"
                fi
            fi
        fi
done


line=$(awk -F ";" -v value=$old_column_value -v colindex=$(($column_index)) '{if($colindex==value) print NR}'  Database/$dbName/$table);
no_rows=0
if [[ ! -z "$line" ]]
then
    lines=''
    for i in $line
    do
        sed -i "$i s/$old_column_value/$new_column_value/g" Database/$dbName/$table
        no_rows=$(($no_rows+1))
    done

    zenity --info --width="200" --text="[$no_rows] rows updated"

    no_of_columns=$(wc -l Database/$dbName/.metadata/$table.meta | cut -d " " -f1)


    columns=()
    rows=()

    for (( i = 1; i<=$no_of_columns; i++ ))
    do
        column_name=$(awk "NR==$i" Database/$dbName/.metadata/$table.meta | cut -d ';' -f1)
        columns+=("--column=$column_name")
    done

    for irow in `cat Database/$dbName/$table `
    do
        
    for (( i = 1; i<=$no_of_columns; i++ ))
    do
            row=$(echo $irow | cut -d ';' -f$i)
            rows+=($row)
    done

    done

    zenity --list  --cancel-label="Back"  --title="Table $table Records"  --width="500" --height="300" "${columns[@]}" "${rows[@]}"
    if [ $? -eq 1 ]
    then
        tableMenu $dbName $table
    fi 
else
        zenity --info --width="200" --text="[$no_rows] rows found"
        tableMenu $dbName $table
fi
