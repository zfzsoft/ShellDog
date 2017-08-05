#!/bin/sh
#
#  usage: 
#  app.sh run ttgate ttonline ttlogger
#  app.sh stop ttgate ttonline ttlogger
#  app.sh update ...
#

bin_path=/Users/zfz/test/app/bin
log_path=/Users/zfz/test/app/logs
update_path=/Users/zfz/test/proj/bin

# cmd: run stop update
command=$1

for app in {$2,$3,$4}
do
    if [ -n "$app" ]; then

    	# srv checking!!!
    	if [ "$app" != "ttgate" ] && [ "$app" != "ttlogger" ] && [ "$app" != "ttonline" ]; then
    		continue
    	fi

    	pid_app=$(ps aux | grep "[./]$app" | awk '{print $2}')
		if [ -n "${pid_app}" ]; then
			echo "stop $app..."
			kill $pid_app

			while ps -p ${pid_app} > /dev/null; do 
				echo 'wait 1s...'
				sleep 1
			done
			echo "stop $app($pid_app) success"
		fi

		if [ "$command" == "stop" ]; then
			if [ -z "${pid_app}" ]; then
				echo "$app not found"
			fi
			echo "---------------------"
			continue;
		fi

		if [ "$command" == "update" ]; then 
			# copy for update
			conf=${app##*tt}.ini
			if [ -e $update_path/$conf ]; then
				echo "update $conf"
    			cp -f $update_path/$conf $bin_path
    		else 
    			echo "$conf update fail, file not found"
			fi
			
			if [ -e "$update_path/$app" ]; then
				echo "update $app"
    			cp -f $update_path/$app $bin_path
    		else 
    			echo "$app update fail, file not found"
			fi
		fi

		if [[ "$command" == "run" || "$command" == "update" ]]; then
			echo "run $app"
			if [ -e "$bin_path/$app" ]; then
				cd $bin_path
				./$app -t1 -l3 >> $log_path/$app.log &
			else
				echo "$app run fail, file not found, use update to install"
			fi
			echo "---------------------"
		fi
	fi
done

echo "OVER"