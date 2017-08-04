#!/bin/sh
#
#  usage: 
#  tt.sh run ttgate ttonline ttlogger
#  tt.sh stop ttgate ttonline ttlogger
#  tt.sh update ...
#

bin_path=/Users/zfz/app/bin
log_path=/applogger/logs
update_path=/Users/zfz/proj/bin

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
		elif [ "$command" == "stop" ]; then
			echo "$app not found"
		fi

		if [ "$command" == "stop" ]; then
			if [ -n "${pid_app}" ]; then
				echo "---------------------"
			fi
			continue;
		fi

		if [ "$command" == "update" ]; then 
			# copy for update
			if [ -e "$update_path/$app" ]; then
				echo "update $app"
    			cp -f $update_path/$app $bin_path
    		else 
    			echo "$app update fail, file not found"
			fi
		fi

		if [[ ("$command" == "run" || "$command" == "update") && ( -n "${bin_path}") ]]; then
			echo "run $app"
			cd $bin_path
			./$app -t1 -l3 >> $log_path/$app.log &
			echo "---------------------"
		fi
	fi
done

echo "OVER"