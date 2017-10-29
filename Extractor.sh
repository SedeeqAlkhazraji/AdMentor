#author: Sedeeq Al-khazraji
#sha6709@rit.edu

for file in *.csv
do
 # do something on $file
 if [ -f "$file" ]
 then
		echo "$file" >> Second.txt
        #Extract last statictic section from result
        grep -A28 "Application State Statistics" "$file" > "$file".txt

        #Extract 4th column
        awk -F "\"*,\"*" '{print $4}' "$file".txt  > "$file"_column.txt

        # Convert to row
        cat "$file"_column.txt | tr '\n' ',' >> Second.txt
		echo "&" >> Second.txt
		
		rm "$file".txt
		rm "$file"_column.txt
fi
done

cat Second.txt | tr '\n' ';' |  sed 's/,,&;/\n/g' | sed 's/;,/,/g'  > SecondFinal.csv

#rm Second.txt
