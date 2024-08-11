#! /bin/bash

# using sourcing
. ././functions/functions.sh


column="$(awk "NR>0" Database/$dbName/.metadata/$table.meta | awk -F ';' '{print $1}' | zenity --list --height="250" --width="300" --title="Table $table Columns" --text="Select Your Choosen Column"  --column="Columns" 2>>.errorlog)"

column_index=$(grep -n "$column" Database/$dbName/.metadata/$table.meta | cut -d ':' -f1)

column_type=$(grep -n "$column" Database/$dbName/.metadata/$table.meta | cut -d ':' -f2 | cut -d ';' -f2)

while true
do
    column_value=$(zenity --entry \
    --title="Enter The $column Value" \
    --cancel-label="Back" \
    --text="SELECT * FROM $table WHERE $column = " \
    --width="200" \
    --entry-text "")

      if [[ -z "$column_value" ]]
        then 
            zenity --error --width="300" --text="Column [$column] field cannot be empty"
        else
        
            if [[ $column_type == "Integer" ]]
            then
                if [[ $column_value =~ ^[0-9]+$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts integers only"
                fi
            fi

            if [[ $column_type == "String" ]]
            then
                if [[ $column_value =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
                then
                    break
                else
                    zenity --error --width="300" --text="Column [$column] is accepts string only"
                fi
            fi
        fi
done


no_of_columns=$(wc -l Database/$dbName/.metadata/$table.meta | cut -d " " -f1)


columns=()
rows=()

for (( i = 1; i<=$no_of_columns; i++ ))
do
    column_name=$(awk "NR==$i" Database/$dbName/.metadata/$table.meta | cut -d ';' -f1)
    columns+=("--column=$column_name")
done

for irow in `awk -F ';' -v value=$column_value -v colindex=$(($column_index)) '{if($colindex==value){print $0}}' Database/$dbName/$table`
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
