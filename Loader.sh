#author: Sedeeq Al-khazraji
#sha6709@rit.edu

#How to run
#./NormalAndTrepn.sh TIME FileSuffex PhoneOutputDirectory > allout.txt 2>&1
#./NormalAndTrepn.sh 60 1 test1 > allout.txt 2>&1
#Loop for all files in current directory

#First Method mixaning
#Remove everything first
adb shell "su -c rm /data/myWork/res/*.txt "
adb shell "su -c rm /data/local/tmp/*.txt "
adb shell "su -c rm /data/local/tmp/com.* "
###
adb shell "su -c 'echo 25 > /sys/class/leds/lcd-backlight/brightness'"
count=100
for file in *.apk
do
 # do something on $file
 if [ -f "$file" ] 
 then
 	let "count += 1"
 	adb install "$file"
 	
	pkg=$(aapt  dump badging "$file"|awk -F" " '/package/ {print $2}'|awk -F"'" '/name=/ {print $2}')
	#act=$(aapt  dump badging "$file"|awk -F" " '/launchable-activity/ {print $2}'|awk -F"'" '/name=/ {print $2}') #MAC
	act=$(aapt  dump badging "$file"|awk -F" " '/launchable activity name/ {print $3}'|awk -F"'" '/name=/ {print $2}') 

	echo "Pkg NO: = $count " 
	echo "Analysis Time: = $1 " 

	echo $pkg
	echo $act
	echo "Installing $pkg"

	adb shell am start -n $pkg/$act

	echo 'Open service'
	adb shell am startservice com.quicinc.trepn/.TrepnService
	sleep 1

	echo 'Load preferences'
	adb shell am broadcast -a com.quicinc.trepn.load_preferences –e com.quicinc.trepn.load_preferences_file "/storage/emulated/0/trepn/saved_preferences/pref1.pref"
	sleep 1
	
	echo 'Start profiling'
	adb shell am broadcast -a com.quicinc.trepn.start_profiling -e com.quicinc.trepn.database_file "$count$pkg$2.db"
	#sleep $1
	
	#First Method mixaning
	adb shell "su -c /data/myWork/phd_sstrc.sh $count $pkg $1 " 
	###
	
	
	echo 'Stop profiling'
	adb shell am broadcast -a com.quicinc.trepn.stop_profiling
	sleep 1

	adb shell am broadcast -a com.quicinc.trepn.export_to_csv -e com.quicinc.trepn.export_db_input_file "$count$pkg$2.db" -e com.quicinc.trepn.export_csv_output_file "$count$pkg$2.csv"
	echo 'Generating CSV file'
	sleep 1

	adb uninstall $pkg
	echo "uninstalling $pkg"
   	adb shell "su -c chmod 777 /storage/emulated/0/trepn/$count$pkg$2.csv "
   	adb shell "su -c cp /storage/emulated/0/trepn/$count$pkg$2.csv /data/local/tmp "
   	adb shell "su -c chmod 777 /data/local/tmp/$count$pkg$2.csv "

	#mkdir /Users/sha6709/Desktop/mytmpTrepn/ #MAC
 	#adb pull /data/local/tmp/allMetrics.csv /Users/sha6709/Desktop/mytmpTrepn/ #MAC
	
	#adb pull /data/local/tmp/$pkg$2.csv D:\\E\\data
	adb pull /data/local/tmp/$count$pkg$2.csv C:\\cygwin64\\home\\Sedee\\test
	
	
	fi 
done

#First Method mixaning
#Extract final.txt from phone and generate DB (Currently it is useless DB)
adb shell "su -c /data/myWork/conv.sh " 
adb shell "su -c chmod 777 /data/myWork/res/final.txt "
adb shell "su -c cp /data/myWork/res/final.txt /data/local/tmp "
adb shell "su -c chmod 777 /data/local/tmp/final.txt "

adb pull /data/local/tmp/final.txt C:\\cygwin64\\home\\Sedee\\test
#cp /Users/sha6709/Desktop/final.txt /Users/sha6709/Library/Android/sdk/platform-tools/apks/
#../sqlite3 adsnetwork.db < generateDB.txt 

#Extract 
adb shell "su -c chmod 777 /data/myWork/res/*.txt "
adb shell "su -c cp /data/myWork/res/*.txt /data/local/tmp "
adb shell "su -c chmod 777 /data/local/tmp/*.txt "
#mkdir /Users/sha6709/Desktop/mytmp/
adb pull /data/local/tmp/ C:\\cygwin64\\home\\Sedee\\test
mv allout.txt C:\\cygwin64\\home\\Sedee\\test
mv C:\\cygwin64\\home\\Sedee\\test\\final.txt C:\\cygwin64\\home\\Sedee\\test\\final.csv

#mv /Users/sha6709/Desktop/final.txt /Users/sha6709/Desktop/mytmp/
###


adb shell "su -c mkdir /storage/emulated/0/trepn/$3 "
adb shell "su -c mv /storage/emulated/0/trepn/*.csv /storage/emulated/0/trepn/$3 "
adb shell "su -c mv /storage/emulated/0/trepn/*.db /storage/emulated/0/trepn/$3 "
adb shell "su -c rm /data/local/tmp/*.csv "
adb shell "su -c rm /data/local/tmp/*.txt "

adb shell "su -c 'echo 70 > /sys/class/leds/lcd-backlight/brightness'"
