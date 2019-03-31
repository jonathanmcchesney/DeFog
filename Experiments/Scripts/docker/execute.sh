#!/bin/bash

function remove_files_before_start {
	# remove result files
	rm /mnt/results/cloudresult.txt
	rm /mnt/results/arrresult.txt
}

function navigate_to_application {
	cd $pathToApplication

	chmod 777 $access1
	chmod 777 $access2
}

function initiate_metric_array {
	# instantiate metricsValues
	metricsValues=('NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA')
}

function set_config {
	source /mnt/configs/config.sh
	
	cloudaddress1="${cloudaddress/$'\r'/}"
	clouduser1="${clouduser/$'\r'/}"
	edgeawskey1="${edgeawskey/$'\r'/}"

	cloudaddress2="${cloudaddress1/$'\n'/}"
	clouduser2="${clouduser1/$'\n'/}"
	edgeawskey2="${edgeawskey1/$'\n'/}"
	
	chmod 400 /mnt/configs/csc4006awskey.pem
}

function set_config_foglamp {
	source /mnt/configs/config.sh
	
	new_address1="${foglampaddress/$'\r'/}"
	new_address2="${foglampaddress1/$'\n'/}"
}

function stop_foglamp {
	scripts/foglamp stop
}

function start_foglamp {
	scripts/foglamp start
}

function which_program_cloud_split_pipeline {

	if [ "$application" == 0 ] # YOLO
	then
	
		rm /mnt/assets/yolov3-tiny.weights
		cd ~/Experiments/YOLO/bothcloudyolo
		mv ./yolov3-tiny.weights /mnt/assets/

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		rm -rf /mnt/assets/en-us
		cd ~/Experiments/PocketSphinx/bothcloudpsphinx
		mv ./en-us /mnt/assets/

	elif [ "$application" == 2 ] # Aeneas
	then
		rm -rf /mnt/assets/aeneas-assets/
		cd ~/Experiments/Aeneas/bothcloudaeneas
		mv ./aeneas-assets/ /mnt/assets/
	fi
}

function which_program_edge_split_pipeline {
	access1=""
	access2=""
	
	if [ "$application" == 0 ] # YOLO
	then
		access1=darknet
		access2=s3Upload.py
		
		predictions=./predictions.png
		returned_predictions=./returnedasset.png
		
		pathToApplication=~/Experiments/YOLO/yolo
		
		executeApplication="./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg"

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=./result.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/Experiments/PocketSphinx/sphinxbase/
		export LD_LIBRARY_PATH=/usr/local/lib
		
		pathToApplication=~/Experiments/PocketSphinx/sphinxbase/pocketsphinx/
		
		executeApplication="pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null"
		
	elif [ "$application" == 2 ] # Aeneas
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=./map.smil
		returned_predictions=./returnedasset.smil
		
		cd ~/Experiments/Aeneas/aeneas
		export PYTHONIOENCODING=UTF-8
		
		pathToApplication=~/Experiments/Aeneas/aeneas
		
		file=$( cat /mnt/assets/aeneas.txt )
		new_file="${file%%.*}"
		
		executeApplication='export PYTHONIOENCODING=UTF-8 && python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     ./$new_file.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil'

	fi
}

function which_program_only_pipelines {
	access1=""
	access2=""
	
	if [ "$application" == 0 ] # YOLO
	then
		access1=darknet
		access2=s3Upload.py
		
		predictions=./predictions.png
		returned_predictions=./returnedasset.png
		
		pathToApplication=~/Experiments/YOLO/yolo
		
		executeApplication="./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg"

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=./result.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/Experiments/PocketSphinx/sphinxbase/
		export LD_LIBRARY_PATH=/usr/local/lib
		
		pathToApplication=~/Experiments/PocketSphinx/sphinxbase/pocketsphinx/
		
		executeApplication="pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null"
		
	elif [ "$application" == 2 ] # Aeneas
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=./map.smil
		returned_predictions=./returnedasset.smil
		
		cd ~/Experiments/Aeneas/aeneas
		export PYTHONIOENCODING=UTF-8
		
		pathToApplication=~/Experiments/Aeneas/aeneas
		
		executeApplication='export PYTHONIOENCODING=UTF-8 && python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     /mnt/assets/aeneastext.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil'
	
	elif [ "$application" == 3 ] # FogLamp
	then
		set_config_foglamp
	
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=./foglampoutput.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/FogLAMP
		export FOGLAMP_ROOT=/root/FogLAMP
		
		pathToApplication=~/FogLAMP
		executeApplication=". foglampcurlcommand.sh $new_address2 >> foglampoutput.txt"

	fi
}

function execute_cloud_to_edge_transfer {

	start=$(date +%s.%N)
	
	if [ "$application" == 0 ] # YOLO
	then
	
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/fogbench/assets/yolov3-tiny.weights ./ 2>&1 | grep "Transferred") 		

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/fogbench/assets/en-us/* ./model/en-us/ 2>&1 | grep "Transferred") 		

	elif [ "$application" == 2 ] # Aeneas
	then
	
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/fogbench/assets/aeneas-assets/text/$new_file.xhtml ./ 2>&1 | grep "Transferred")
		
	fi

	nocarriagereturns=${transfer_cloud//[!0-9\\ \\.]/}
	newarr1=(`echo ${nocarriagereturns}`);
	
	end=$(date +%s.%N)
	runtime=$( echo "$end - $start" | bc -l )
	
	echo "Cloud to Edge Transfer: completed in $runtime secs" | tee -a results.txt
	metricsValues[9]=${newarr1[1]}
	metricsValues[13]=$runtime
	
}

function execute_program_only {
	# capture the time taken for computation
	start=$(date +%s.%N)
	$executeApplication
	end=$(date +%s.%N)
	
	runtime=$( echo "$end - $start" | bc -l )
	echo "Computation: completed in $runtime secs" | tee -a results.txt
	
	# set execution time metric
	metricsValues[1]=$runtime
}

function upload_to_s3 {
	echo "Starting Upload to S3 Bucket..."
	# capture time it takes to transfer to the S3 bucket
	start=$(date +%s.%N)
	python s3Upload.py $predictions $predictions
	end=$(date +%s.%N)
	
	runtime=$( echo "$end - $start" | bc -l )
	echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

	# set upload time metric
	metricsValues[2]=$runtime
}

function calc_rtf {
	length=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 /mnt/assets/psphinx.wav)
	metricsValues[5]=$length
}

function save_to_files {
	# save data to the results file(s) and move results/data to relevant folder
	cat results.txt >> /mnt/results/cloudresult.txt
	echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

	cp $predictions $returned_predictions
	mv $returned_predictions /mnt/results/
}

function set_application {
	echo hello $1
	application=$1
	echo app $application
}

function set_pipeline {
	echo hi $1
	pipeline=$1
	echo pipeline $pipeline
}

function execute_cloud_split_pipeline {	
	
	which_program_cloud_split_pipeline
	
}

function execute_edge_split_pipeline {	
	
	remove_files_before_start
	set_config
	
	which_program_edge_split_pipeline
	navigate_to_application
	initiate_metric_array
	
	execute_cloud_to_edge_transfer
	
	execute_program_only
	
	if [ "$application" == 1 ]; # Pocket Sphinx
	then
		calc_rtf
	fi
	
	upload_to_s3
	save_to_files
}

function execute_only_pipelines {	
	remove_files_before_start
	
	which_program_only_pipelines
	navigate_to_application
	initiate_metric_array
	
	if [ "$application" == 3 ]; # FogLamp
	then
		start_foglamp
	fi
	
	execute_program_only
	
	if [ "$application" == 3 ]; # FogLamp
	then
		stop_foglamp
	fi
	
	if [ "$application" == 1 ]; # Pocket Sphinx
	then
		calc_rtf
	fi
	
	upload_to_s3
	save_to_files
}

set_application $1
set_pipeline $2

if [ "$pipeline" == 0 ]; # Cloud or Edge Only
then
	execute_only_pipelines
elif [ "$pipeline" == 1 ]; # Cloud Split
then
	execute_cloud_split_pipeline	
elif [ "$pipeline" == 2 ]; # Edge Split
then
	execute_edge_split_pipeline
fi

while getopts :yljp:bcez: opt; do
    case "$opt" in
        y)
            application=0
            ;;	
		l)
            application=3
            ;;
		j)
			application=2
            ;;
        p)
			application=1          
            ;;
		b)
            pipeline=2
            ;;	
		c)
            pipeline=0
            ;;
		z)
			pipeline=1
            ;;
        e)
			pipeline=0          
            ;;	
    esac
done

#main

exit
