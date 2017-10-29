#author: Sedeeq Al-khazraji
#sha6709@rit.edu

if [ $# -eq 0 ]; then
	echo "Your command line contains no arguments"
	echo "Please input one or more of the following options:"
	echo "\t 1'st parameter: arbitrary number for file prefix Id "
	echo "\t 2'nd parameter: Your_Package_Name your applicationId as used in Android studio build.gradle "
	echo "\t 3'rd parameter: How long time you want to track the package"
	echo "\t [sys_call]: \t for dispalying number ant type of system calls happend by your package"
	echo "\t [mem]: \t for dispalying memory information"
	echo "\t [cpu]: \t for dispalying cpu information"
	echo "\t [net]: \t for dispalying network information"
	echo "\t [bat]: \t for dispalying battary information"
	exit
fi

if [ $# -lt 3 ]; then
	echo "Your command line contains no arguments"
	echo "Please input one or more of the following options:"
	echo "\t 1'st parameter: arbitrary number for file prefix Id "
	echo "\t 2'nd parameter: Your_Package_Name your applicationId as used in Android studio build.gradle "
	echo "\t 3'rd parameter: How long time you want to track the package"
	echo "\t [sys_call]: \t for dispalying number ant type of system calls happend by your package"
	echo "\t [mem]: \t for dispalying memory information"
	echo "\t [cpu]: \t for dispalying cpu information"
	echo "\t [net]: \t for dispalying network information"
	echo "\t [bat]: \t for dispalying battary information"
	exit
fi

touch /data/myWork/res/$1_$2_$3.txt
echo '' > /data/myWork/res/$1_$2_$3.txt

touch /data/myWork/res/$1_$2_$3_summary.txt
echo '' > /data/myWork/res/$1_$2_$3_summary.txt


echo 'Please run your pacakage '
echo 'Waiting... '
while [ ! $(pidof $2) ]
do :
done;

echo 'Starting... '
echo ''

#Default value, include all Metrics
if [ $# -eq 3 ]; then

	#if [ "$i" == "sys_call" ]; then 
		echo $1';'$2 >> /data/myWork/res/$1_$2_$3_summary.txt

		echo '***   Syatem Call  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		top | grep $(pidof $2) | awk '{print $8}'  > sumout.txt 2>&1 &

		timeout -t $3 /data/myWork/strace -f -c  -p $(pidof $2) -o /data/myWork/res/$1_$2_$3_temp.txt
		cat /data/myWork/res/$1_$2_$3_temp.txt 
		cat /data/myWork/res/$1_$2_$3_temp.txt >> /data/myWork/res/$1_$2_$3.txt
		cat /data/myWork/res/$1_$2_$3_temp.txt | grep total | awk '{print $3}' | head -1 >> /data/myWork/res/$1_$2_$3_summary.txt
		rm /data/myWork/res/$1_$2_$3_temp.txt
		echo '====================== '
		echo ''
		echo ''
	
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		echo '' >> /data/myWork/res/$1_$2_$3.txt
		echo '' >> /data/myWork/res/$1_$2_$3.txt
	
	#if [ "$i" == "mem" ]; then 
	
		echo '***   Memory Info  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo 'Total Dirty Clean'    | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '----- ----- ----- ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		dumpsys meminfo $(pidof $2) | grep TOTAL | awk '{print $2, $3, $4}' | head -1 | tee -a /data/myWork/res/$1_$2_$3.txt 
		tail -1 /data/myWork/res/$1_$2_$3.txt | awk '{print $1";"$2";"$3}' >> /data/myWork/res/$1_$2_$3_summary.txt 		
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt 
	
	#if [ "$i" == "cpu" ]; then 

		echo '***    CPU Info    *** ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '-CPU usage percintage: ' | tee -a /data/myWork/res/$1_$2_$3.txt
		dumpsys cpuinfo | grep $(pidof $2)  | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '-Total CPU time consumed in "clock ticks": ' 	| tee -a /data/myWork/res/$1_$2_$3.txt
		cat /proc/$(pidof $2)/stat | awk '{print $14}'	| tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt

		echo '-Total CPU time consumed in "%": ' 	| tee -a /data/myWork/res/$1_$2_$3.txt
		awk '{ sum += $1; cout += 1;  av = sum/cout} END { print av }' sumout.txt | tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		rm sumout.txt
	
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt
	
	#if [ "$i" == "net" ]; then 
 
		echo '***  Network Info  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 


		if [ -f /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_snd ]; then
			echo '-SEND DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			cat /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_snd | tee -a  /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		else
			echo '-SEND DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			echo '0' | tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		fi

		if [ -f /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_rcv ]; then
			echo '-RECIVED DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			cat /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_rcv | tee -a  /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		else
			echo '-RECIVED DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			echo '0' | tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		fi

		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '' | tee -a /data/myWork/res/$1_$2_$3.txt

	#if [ "$i" == "bat" ]; then 
		#echo '*** BATERRY Info 1 *** ' 
		#echo '====================== ' 
		#dumpsys gfxinfo $2
		#echo '*** BATERRY Info 2 *** ' 
		#echo '====================== ' 
		#dumpsys batterystats --charged $2		  

		#echo '*** BATERRY Info 1 *** ' >> /data/myWork/res/$1_$2_$3.txt
		#echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		#dumpsys gfxinfo $2	>> /data/myWork/res/$1_$2_$3.txt
		#echo '*** BATERRY Info 2 *** ' >> /data/myWork/res/$1_$2_$3.txt
		#echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		#dumpsys batterystats --charged $2		  >> /data/myWork/res/$1_$2_$3.txt
	
	tr '\n' ';'  < /data/myWork/res/$1_$2_$3_summary.txt >> /data/myWork/res/final_summary.txt
	echo '&' >> /data/myWork/res/final_summary.txt
	rm /data/myWork/res/$1_$2_$3_summary.txt

	echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
	echo '          DONE         ' | tee -a /data/myWork/res/$1_$2_$3.txt
	echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt

	exit
fi

#Check if developer used sys_call parameter, if YES then we don't need timeout command, if NO then we need to use timeout command
needtouse_timeout_cmd=true

#First test for sys_call parameter 
for i in "$@" 
do

	if [ "$i" == "sys_call" ]; then 
	
		echo '***   Syatem Call  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 
	
		timeout -t $2 /data/myWork/strace -f -c  -p $(pidof $2) -o /data/myWork/res/$1_$2_$3_temp.txt
		cat /data/myWork/res/$1_$2_$3_temp.txt 
		cat /data/myWork/res/$1_$2_$3_temp.txt >> /data/myWork/res/$1_$2_$3.txt
		cat /data/myWork/res/$1_$2_$3_temp.txt | grep total | awk '{print $3";"$4}' | head -1 >> /data/myWork/res/$1_$2_$3_summary.txt
		rm /data/myWork/res/$1_$2_$3_temp.txt
		echo '====================== '
		echo ''
		echo ''
	
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		echo '' >> /data/myWork/res/$1_$2_$3.txt
		echo '' >> /data/myWork/res/$1_$2_$3.txt
		needtouse_timeout_cmd=false
	fi
done


if [ "$needtouse_timeout_cmd" = true ] ; then
    timeout -t $2 sleep $2
fi

#Test all other parameter
for i in "$@" 
do

	if [ "$i" == "mem" ]; then 
		echo '***   Memory Info  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo 'Total Dirty Clean'    | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo '----- ----- ----- ' | tee -a /data/myWork/res/$1_$2_$3.txt 
		dumpsys meminfo $(pidof $2) | grep TOTAL | awk '{print $2, $3, $4}' | head -1 | tee -a /data/myWork/res/$1_$2_$3.txt 
		tail -1 /data/myWork/res/$1_$2_$3.txt | awk '{print $1";"$2";"$3}' >> /data/myWork/res/$1_$2_$3_summary.txt 		
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt 
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt 
	fi

	if [ "$i" == "cpu" ]; then 
		echo '***    CPU Info    *** ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '-CPU usage percintage: ' | tee -a /data/myWork/res/$1_$2_$3.txt
		dumpsys cpuinfo | grep $(pidof $2)  | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '-Total CPU time consumed in "clock ticks": ' 	| tee -a /data/myWork/res/$1_$2_$3.txt
		cat /proc/$(pidof $2)/stat | awk '{print $14}'	| tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt
		echo ''  | tee -a /data/myWork/res/$1_$2_$3.txt
	fi

	if [ "$i" == "net" ]; then 
		echo '***  Network Info  *** ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt 


		if [ -f /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_snd ]; then
			echo '-SEND DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			cat /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_snd | tee -a  /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		else
			echo '-SEND DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			echo '0' | tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		fi

		if [ -f /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_rcv ]; then
			echo '-RECIVED DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			cat /proc/uid_stat/$(cat /proc/$(pidof $2)/status |  grep Uid | grep [0-9][0-9][0-9][0-9][0-9] -o | sort | uniq)/tcp_rcv | tee -a  /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		else
			echo '-RECIVED DATA:' | tee -a /data/myWork/res/$1_$2_$3.txt 
			echo '0' | tee -a /data/myWork/res/$1_$2_$3.txt /data/myWork/res/$1_$2_$3_summary.txt
		fi

		echo '====================== ' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '' | tee -a /data/myWork/res/$1_$2_$3.txt
		echo '' | tee -a /data/myWork/res/$1_$2_$3.txt

	fi

	if [ "$i" == "bat" ]; then 
		echo '*** BATERRY Info 1 *** ' 
		echo '====================== ' 
		dumpsys gfxinfo $2
		echo '*** BATERRY Info 2 *** ' 
		echo '====================== ' 
		dumpsys batterystats --charged $2		  

		echo '*** BATERRY Info 1 *** ' >> /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		dumpsys gfxinfo $2	>> /data/myWork/res/$1_$2_$3.txt
		echo '*** BATERRY Info 2 *** ' >> /data/myWork/res/$1_$2_$3.txt
		echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
		dumpsys batterystats --charged $2		  >> /data/myWork/res/$1_$2_$3.txt
	fi

done

#tr '\n' ';'  < /data/myWork/res/$1_$2_$3_summary.txt > /data/myWork/res/$1_$2_$3_final_summary.txt
rm /data/myWork/res/$1_$2_$3_summary.txt
#rm /data/myWork/res/$1_$2_$3_final_summary.txt # Because we don't know the order of the parameter that the developer entered, so we can't create DB.
echo '====================== '
echo '          DONE         ' 
echo '====================== '

echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
echo '          DONE         ' >> /data/myWork/res/$1_$2_$3.txt
echo '====================== ' >> /data/myWork/res/$1_$2_$3.txt
