#!/bin/bash

# help function that displays commandline help to the user
function HELP {
    cat <<HELP
	Help: DeFog: Demystifying Fog Systems Interaction via Container based benchmarking [OPTION...]
	DeFog allows you to build and run applications through container based benchmarks, select the desired environment as well as the application to benchmark.

	Environments:

	- Run Benchmarks on both Cloud and Edge
	- Run Benchmarks on Cloud Only
	- Run Benchmarks on Edge Only

	Pre-Setup Edge Devices:
	- Odroid XU4
	- Raspberry Pi

	Actions:
	- Run all system benchmarks
	- Runs small and large weight downloads test
	- Test large file create/remove speed
	- Run Sysbench
	- Run UnixBench
	- Delete temporary files
	- Run Simple System Benchmarks
	- No actions

	Applications Benchmarks:
	- Run Yolo
	- Run Pocket Sphinx
	- Run Aeneas
	- Build and Run iPokeMon
	- Run iPokeMon
	- Run FogLAMP
	- No Applications

HELP
}

# function to invoke commandline help by sshing into destination using identity file
function executebenchmarkhelp {
		# ssh -i $awskey $clouduser@$cloudaddress 'bash -s' -- < ./defog -?
		./defogexecute -?
}

# function to invoke the actions bash file on the cloud-edge pipeline by sshing into both the cloud and edge and calling the actions bash script
# passing the relevant variables as file parameters.
function benchmark_both_actions {
		echo "ssh into edge/cloud - cloud instance for actions and system benchmarks.."
		ssh -i $awskey $clouduser@$cloudaddress ' sudo bash -s' -- < ./actions -z $actions $applications # environment variable is set to a different value for remote invocation
		echo "Done cloud ssh session"
		
		echo "ssh into edge instance for actions and system benchmarks.."
		ssh $edgeuser@$edgeaddress ' sudo bash -s' -- < ./actions $environment $actions $applications
		echo "Done edge ssh session"	
}

# function to invoke the application bash file on the cloud-edge pipeline by sshing into both the cloud and edge and calling the actions bash script
# passing the relevant variables as file parameters. The results are then transferred back from the edge as necessary.
function benchmark_both_applications {
		echo "ssh into edge/cloud - cloud instance for applications benchmarks.."
		ssh -i $awskey $clouduser@$cloudaddress ' sudo bash -s' -- < ./applications -z $actions $applications
		echo "Done cloud ssh session"
		
		echo "ssh into edge/cloud instance for applications benchmarks.."
		ssh $edgeuser@$edgeaddress ' sudo bash -s' -- < ./applications $environment $actions $applications
		echo "Done edge ssh session"	
		
		# calculate the time taken to transfer data (i.e. resutlts and data files from the edge to the local user device
		local start=$(date +%s.%N)
		local transfer_cloud=$(scp -v $edgeuser@$edgeaddress:~/fogbench/results/* ./ 2>&1 | grep "Transferred") 		
		local newval=${transfer_cloud//[!0-9\\ \\.]/}
		newarr1=(`echo ${newval}`);
		local end=$(date +%s.%N)
		local runtime=$( echo "$end - $start" | bc -l )
		
		# set the transfer time, bytes transfered down and bytes per second down and set to the relevant metric index
		metricsValues[3]=$runtime
		metricsValues[8]=${newarr1[1]}
		metricsValues[11]=$(bc <<< "scale=10;${metricsValues[8]}/${metricsValues[3]}")
		
		# rename verbose results file, remove old file
		cat cloudresult.txt >> $verbose_filename.txt
		rm cloudresult.txt
		
		# read in results data file, save to array, remove old file
		read -a newarr < arrresult.txt 
		rm arrresult.txt
		
		# print and save data to file
		echo Total bytes transferred from the edge: ${metricsValues[8]} bytes | tee -a $verbose_filename.txt
		echo Transfer both pipeline edge application results to edge device: completed in $runtime secs | tee -a $verbose_filename.txt
		echo Transfer rate from the edge: ${metricsValues[11]} bytes per second | tee -a $verbose_filename.txt
		
		# invoke the set_returned_application_metrics function to set data metrics to global array
		set_returned_application_metrics	
		
		# calculate the bytes per second down from the cloud to the edge and save to array	
		metricsValues[12]=$(bc <<< "scale=10;${metricsValues[9]}/${metricsValues[13]}")
		echo "" | tee -a $verbose_filename.txt
}

function benchmark_edge_actions {
		echo "ssh into edge instance for actions and system benchmarks.."
		ssh $edgeuser@$edgeaddress ' sudo bash -s' -- < ./actions $environment $actions $applications
		echo "Done edge ssh session"
		
		local start=$(date +%s.%N)
		scp $edgeuser@$edgeaddress:~/fogbench/results/* ./
		local end=$(date +%s.%N)
		local runtime=$( echo "$end - $start" | bc -l )
		
		cat edgeresult.txt >> $verbose_filename.txt
		rm edgeresult.txt
		
		echo Transfer edge action results to edge device: completed in $runtime secs | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt
		
}

function benchmark_edge_applications {
		
		echo "ssh into edge instance for application benchmarks.."
		ssh	$edgeuser@$edgeaddress ' sudo bash -s' -- < ./applications $environment $actions $applications
		echo "Done edge ssh session"
		
		local start=$(date +%s.%N)
		local transfer_cloud=$(scp -v $edgeuser@$edgeaddress:~/fogbench/results/* ./ 2>&1 | grep "Transferred") 		
		local newval=${transfer_cloud//[!0-9\\ \\.]/}
		newarr1=(`echo ${newval}`);
		local end=$(date +%s.%N)
		local runtime=$( echo "$end - $start" | bc -l )
		metricsValues[3]=$runtime
		metricsValues[8]=${newarr1[1]}
		metricsValues[11]=$(bc <<< "scale=10;${metricsValues[8]}/${metricsValues[3]}")

		cat cloudresult.txt >> $verbose_filename.txt
		rm cloudresult.txt
		
		read -a newarr < arrresult.txt 
		rm arrresult.txt
		
		echo Total bytes transferred from the edge: ${metricsValues[8]} bytes | tee -a $verbose_filename.txt
		echo Transfer edge application results to edge device: completed in $runtime secs | tee -a $verbose_filename.txt
		echo Transfer rate from the edge: metricsValues[11] bytes per second | tee -a $verbose_filename.txt
		
		set_returned_application_metrics	
		
		echo "" | tee -a $verbose_filename.txt
	
}

function benchmark_cloud_actions {
		echo "ssh into cloud instance for actions and system benchmarks.."
		ssh -i $awskey $clouduser@$cloudaddress ' sudo bash -s' -- < ./actions $environment $actions $applications
		echo "Done cloud ssh session"
		
		local start=$(date +%s.%N)
		scp -i $awskey $clouduser@$cloudaddress:~/fogbench/results/* ./
		local end=$(date +%s.%N)
		local runtime=$( echo "$end - $start" | bc -l )
		
		cat cloudresult.txt >> $verbose_filename.txt
		rm cloudresult.txt
		
		echo Transfer cloud action results to edge device: completed in $runtime secs | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt

}

function benchmark_cloud_applications {
		
		echo "ssh into cloud instance for application benchmarks.."
		ssh -i $awskey $clouduser@$cloudaddress ' sudo bash -s' -- < ./applications $environment $actions $applications
		echo "Done ssh"
		
		local start=$(date +%s.%N)
		local transfer_cloud=$(scp -v -i $awskey $clouduser@$cloudaddress:~/fogbench/results/* ./ 2>&1 | grep "Transferred") 		
		local newval=${transfer_cloud//[!0-9\\ \\.]/}
		newarr1=(`echo ${newval}`);
		local end=$(date +%s.%N)
		local runtime=$( echo "$end - $start" | bc -l )
		metricsValues[3]=$runtime
		metricsValues[8]=${newarr1[1]}
		metricsValues[11]=$(bc <<< "scale=10;${metricsValues[8]}/${metricsValues[3]}")
	
		rm returnedasset.*

		cat cloudresult.txt >> $verbose_filename.txt
		rm cloudresult.txt
		
		read -a newarr < arrresult.txt 
		rm arrresult.txt
		
		echo Total bytes transferred from the cloud: ${metricsValues[8]} bytes | tee -a $verbose_filename.txt
		echo Transfer cloud application results to edge device: completed in $runtime secs | tee -a $verbose_filename.txt
		echo Transfer rate from the cloud: metricsValues[11] bytes per second | tee -a $verbose_filename.txt
		
		set_returned_application_metrics		
					
		echo "" | tee -a $verbose_filename.txt
		
}

# calculate the cost of running the benchmarks on the cloud, using AWS price format
function calc_cloud_cost {
	local awshrcost=0.016
	local convert=3600
	local awsseccost=$(bc <<< "scale=10;$awshrcost/$convert")
	local minruntime=60
	local computetime=${metricsValues[1]}
	
	local cost=$(bc <<< "$computetime*$awsseccost")
	
	metricsValues[6]=$cost
	
	echo "Cloud cost for application computation (£0.016 per hour)": £$cost | tee -a $verbose_filename.txt
	
}

# calculate the cost of running the benchmarks on the edge
function calc_edge_cost {
	local edgehrcost=0.008
	local convert=3600
	local edgeseccost=$(bc <<< "scale=10;$edgehrcost/$convert")
	local computetime=${metricsValues[1]}
	
	local cost=$(bc <<< "$computetime*$edgeseccost")
		
	metricsValues[6]=$cost
	
	echo "Edge cost for application computation (estimated £0.008 per hour)": £$cost | tee -a $verbose_filename.txt

}

# calculate the return trip time and communication latency metrics
function calc_rtt {

	local T1=${metricsValues[0]} 
	local E=${metricsValues[1]} 
	local T3=${metricsValues[3]} 
	local T4=${metricsValues[13]}
	
	local cl=$(bc <<< "$T1+$T3") # communication latency
	local rtt=$(bc <<< "$T1+$T3+$E") # round trip time

	metricsValues[4]=$rtt # time to transfer data to and from cloud/edge as well as computation time
	metricsValues[14]=$cl # time to transfer data to and from cloud/edge
	
	echo Round Trip Time: $rtt secs | tee -a $verbose_filename.txt

}

# calculate real time factor for audio applications (computational time / length of audio file in seconds)
function calc_rtf {
	local computation=${newarr[1]}
	local length=${newarr[5]}
	local rtf=$(bc <<< "scale=10;$computation/$length")

	metricsValues[5]=$rtf
	
	echo Real Time Factor: $rtf secs | tee -a $verbose_filename.txt
}

# iterate over metrics returned from the edge or cloud, set them to local array
function set_returned_application_metrics {
	local mets=${#metricsValues[@]}
	local count=1
		
	if [ "${newarr[10]}" != "NA" ];
	then
		metricsValues[13]=${newarr[10]} # set time taken to transfer data from the cloud to the edge
	fi	
	
	for (( i=0; i<=$(( $mets -1 )); i++ ))
	do 
		((count++))
		
		if [ "${metricsValues[$i]}" == "NA" ] && [ "${newarr[$i]}" != "NA" ] && [ "${newarr[$i]}" ];
		then
			metricsValues[$i]=${newarr[$i]} # set retured data to local array
		fi
	done
	
	
}

# invoke the relevant application benchmark utility function
function benchmark_applications {
		pipeline="NA"
		
		# set pipeline variable name to the current pipeline/platform selected
		if [ "$environment" == "-c" ]; then pipeline="Cloud-Only"; 
		elif [ "$environment" == "-e" ]; then pipeline="Edge-Only"; 
		elif [ "$environment" == "-b" ]; then pipeline="Cloud/Edge"; 
		fi
		
		# print application header to verbose file and invoke application benchmarks
		if [ "$applications" == "-y" ];
		then
			echo YOLO Benchmarks: | tee -a $verbose_filename.txt
			seperator
			benchmark_yolo
		elif [ "$applications" == "-p" ];
		then	
			echo Pocket Sphinx Benchmarks: | tee -a $verbose_filename.txt
			seperator
			benchmark_pocket_sphinx
		elif [ "$applications" == "-j" ];
		then	
			echo Aeneas Benchmarks: | tee -a $verbose_filename.txt
			seperator
			benchmark_aeneas	
		elif [ "$applications" == "-i" ];
		then	
			echo iPokeMon Benchmarks: | tee -a $verbose_filename.txt
			seperator
			start_ipokemon_server	
			benchmark_ipokemon
		elif [ "$applications" == "-k" ];
		then	
			echo iPokeMon Benchmarks: | tee -a $verbose_filename.txt
			seperator
			benchmark_ipokemon	
		elif [ "$applications" == "-l" ];
		then	
			echo FogLAMP Benchmarks: | tee -a $verbose_filename.txt
			seperator
			benchmark_foglamp	
		fi	
}

# benchmark iPokemon server
function benchmark_ipokemon {
	cd jmeter/bin # navigate to jmeter bin folder
	
	local host=''
	
	if [ "$environment" == "-c" ];
	then 
		host=$cloudpublicip
	else
		host=$edgeaddress
	fi	

	# run jmeter using user defined variables (automation of jsx file - allows execution on the edge or cloud)
	echo "Running JMeter..."
	./jmeter -n -t iPokeMon1.jmx -JHOST=$host -JDuration=$test_duration -JThreads=$users -JRamp=$ramp_up -l testresults.csv
	
	# run tautus using user defined variables (automation of jmeter jsx file) and using reporting.yaml as a parameter
	echo "Running Taurus..."
	bzt iPokeMon1.jmx -o modules.jmeter.properties.HOST=$host -o modules.jmeter.properties.Duration=$test_duration -o modules.jmeter.properties.Threads=$users -o modules.jmeter.properties.Ramp=$ramp_up reporting.yaml
	
	# move and rename test data files to the results file
	mv testresults.csv ../../results/$jmeter_filename.csv	
	mv taurusreport.csv ../../results/$taurus_filename.csv	
	mv taurusreport.xml ../../results/$taurus_filename.xml	
	
	cd ../../ # navigate to defog folder
}

# setup and start the iPokeMon server
function start_ipokemon_server {
		# determine the platform/pipeline ssh into destination and enter iPokeMon docker container (use ctrl p & ctrl q to detach the container)
		if [ "$environment" == "-c" ] || [ "$environment" == "-b" ];
		then
			ssh -i $awskey $clouduser@$cloudaddress -t "cd fogbench/ipokemonbuild/Experiments/iPokeMon/docker && sudo -sH && . enter.sh; bash"
		fi
		if [ "$environment" == "-e" ] || [ "$environment" == "-b" ];
		then
			ssh $edgeuser@$edgeaddress -t "cd fogbench/ipokemonbuild/Experiments/iPokeMon/docker && sudo -sH && . enter.sh; bash"
		fi	
}
	
# determine the pipeline/platform to benchmark the applications on, invoke the calculation of real time trip and real time factor variables	
function benchmark_application {
		if [ "$environment" == "-c" ]; # cloud only
		then
			benchmark_cloud_applications
			calc_rtt
			if [ "${metricsValues[5]}" != "NA" ];
			then
				calc_rtf
			fi
			calc_cloud_cost
		fi	
		if [ "$environment" == "-e" ]; # edge only
		then
			benchmark_edge_applications
			calc_rtt
			if [ "${metricsValues[5]}" != "NA" ];
			then
				calc_rtf
			fi
			calc_edge_cost
		fi
		if [ "$environment" == "-b" ]; # cloud/edge
		then
			benchmark_both_applications
			calc_rtt
			if [ "${metricsValues[5]}" != "NA" ];
			then
				calc_rtf
			fi
			calc_edge_cost
		fi
		echo ${metricsValues[@]} | tee -a $metrics_verbose_filename.txt
}

#
function benchmark_foglamp {
	declare -a arrCurlCommands
	newassetname=./assets/foglamp-assets/foglampcurlcommand.sh		
	local count=1
	
	for file in ./assets/foglamp-assets/*.sh
	do
	
		create_metric_array
		
		metricsValues[15]=$pipeline
		metricsValues[16]="FogLAMP"
		
		echo -e "" | tee -a $verbose_filename.txt
		echo FogLAMP Benchmark Run $count: | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt
		
		arrCurlCommands=("${Curls[@]}" "$file")
		asset=$arrCurlCommands
		
		echo "Sending asset at path: " $newassetname "to application..."
		scp_asset
		echo "done sending asset"
		
		benchmark_application
		
		((count++))

	done
	
}

#
function benchmark_yolo {
	declare -a arrPics
	newassetname=./assets/yolo-assets/yoloimage.jpg		
	local count=1
	
	for file in ./assets/yolo-assets/*.jpg
	do
	
		create_metric_array
		
		metricsValues[15]=$pipeline
		metricsValues[16]="YOLO"
		
		echo -e "" | tee -a $verbose_filename.txt
		echo YOLO Benchmark Run $count: | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt
		
		arrPics=("${Pics[@]}" "$file")
		asset=$arrPics
		
		echo "Sending asset at path: " $newassetname "to application..."
		scp_asset
		echo "DONE"
		
		benchmark_application
		
		((count++))

	done
	
}

function benchmark_pocket_sphinx {
	declare -a arrWavs
	newassetname=./assets/psphinx-assets/psphinx.wav
	local count=1
	
	for file in ./assets/psphinx-assets/*.wav
	do
		
		create_metric_array
		
		metricsValues[15]=$pipeline
		metricsValues[16]="Pocket-Sphinx"

		echo -e "" | tee -a $verbose_filename.txt
		echo Pocket Sphinx Benchmark Run $count: | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt
		
		arrWavs=("${Wavs[@]}" "$file")
		asset=$arrWavs
		
		echo "Sending asset at path: " $asset "to application..."
		scp_asset
		echo "DONE"
		
		benchmark_application
	
		((count++))

	done	
}

#
function benchmark_aeneas {

	declare -a arrAudios
	
	for file1 in ./assets/aeneas-assets/audio/*.mp3
	do
		arrAudios=("${arrAudios[@]}" "$file1")
	done


	declare -a arrTexts
	
	for file2 in ./assets/aeneas-assets/text/*.xhtml
	do
		local arrTexts=("${arrTexts[@]}" "$file2")	
	done	
		
		
	total=${#arrAudios[@]}
	
	local count=1
	
	for (( j=0; j<=$(( $total -1 )); j++ ))
	do 
		
		multiassets="true"
		create_metric_array
		
		metricsValues[15]=$pipeline
		metricsValues[16]="Aeneas"

		echo -e "" | tee -a $verbose_filename.txt
		echo Aeneas Benchmark Run $count: | tee -a $verbose_filename.txt
		echo "" | tee -a $verbose_filename.txt
		
		asset=${arrAudios[$j]}
		newassetname=./assets/aeneas-assets/aeneasaudio.mp3

		echo "Sending asset at path: " $asset "to application..."
		scp_asset
		echo "DONE"
		
		local oldT1=${metricsValues[0]}
		local oldbu1=${metricsValues[7]}
		
		metricsValues[0]=$oldT1
		metricsValues[7]=$oldbu1
		
		echo this here
		echo	${metricsValues[0]}
		echo 	${metricsValues[7]}	
		asset=${arrTexts[$j]}
		newassetname=./assets/aeneas-assets/aeneastext.xhtml
		
		if [ "$environment" != "-b" ];
		then
			echo "Sending asset at path: " $asset "to application..."
			scp_asset
			echo "DONE"		
		fi	
		
		if [ "$environment" == "-b" ];
		then
			local shortasset="${asset##*/}"
			echo $shortasset > ./aeneas.txt
			
			asset=./aeneas.txt
			newassetname=./aeneas.txt
			
			echo "Sending asset at path: " $asset "to application..."
			scp_asset
			echo "DONE"		
		fi	
				
		benchmark_application
		
		((count++))
	
	done

}

# instantiate/reset metrics title and value
function create_metric_array {
	declare -g metricsLabels=('T1' 'ET' 'T2' 'T3' 'RTT' 'RTF' 'Cost' 'BytesUp1' 'BytesDown1' 'BytesDown2' 'BytesPerSecUp1' 'BytesPerSecDown1' 'BytesPerSecDown2' 'T4' 'CL' 'Pipeline' 'Application')
	declare -g metricsValues=('NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA')	
}

# secure copy/transfer data/assets to destination platform
function scp_asset {
	TIMEFORMAT=%R # set time format
	cp $asset $newassetname 
	local start=$(date +%s.%N) # start timer to calculat ethe time it takes to transfer data
		
	# transfer data to the cloud and set array metrics to local variable	
	if [ "$environment" == "-c" ]; # cloud only
	then
		local transfer_cloud=$(scp -v -i $awskey $newassetname $clouduser@$cloudaddress:~/fogbench/assets 2>&1 | grep "Transferred") 		
		local newval=${transfer_cloud//[!0-9\\ \\.]/}
		newarr1=(`echo ${newval}`);
	fi	
	
	# transfer data to the edge and set array metrics to local variable	
	if [ "$environment" == "-e" ] || [ "$environment" == "-b" ]; # edge only or cloud/edge
	then
		local transfer_edge=$(scp -v $newassetname $edgeuser@$edgeaddress:~/fogbench/assets 2>&1 | grep "Transferred") 		
		local newval=${transfer_edge//[!0-9\\ \\.]/}
		newarr1=(`echo ${newval}`);
	fi
	
	# determine the time taken to transfer data
	local end=$(date +%s.%N)
	local runtime=$( echo "$end - $start" | bc -l )
	
	# if running an application that sends multiple assets - sum the bytes sent and time taken to transfer the assets
	if [ "$multiassets" == "true" ] && [ "${metricsValues[0]}" != "NA" ];
	then
		metricsValues[0]=$(bc <<< "${metricsValues[0]}+$runtime")
		metricsValues[7]=$(bc <<< "${metricsValues[7]}+${newarr1[0]}")
		local bytesUpVar=$(bc <<< "scale=10;${metricsValues[7]}/${metricsValues[0]}")
		metricsValues[10]=$(bc <<< "$bytesUpVar")
	else
		metricsValues[0]=$runtime
		metricsValues[7]=${newarr1[0]}
		metricsValues[10]=$(bc <<< "scale=10;${metricsValues[7]}/${metricsValues[0]}")
	fi	
	
	# remove duplicate asset
	rm $newassetname

}

# transfer configuration file to the cloud
function send_config_cloud {
	echo sending config to cloud
		scp -i $awskey $configslocation $clouduser@$cloudaddress:~/fogbench/configs 2>&1
	echo done
}

# transfer configuration file to the edge
function send_config_edge {
	echo sending config to edge
		scp $configslocation $edgeuser@$edgeaddress:~/fogbench/configs > /dev/null 2>&1
	echo done

}

# utility function to print sepeartor/formatter line
function seperator {
echo -e "*****************************************************************************" | tee -a $verbose_filename.txt
}

# application main
function main {

	create_metric_array
	
	echo ${metricsLabels[@]} >> $metrics_verbose_filename.txt
	
	if [ "$environment" == "-c" ]; # cloud only
	then
		
		benchmark_cloud_actions
		send_config_cloud
		benchmark_applications
	fi	
	
	if [ "$environment" == "-e" ]; # edge only
	then	
		benchmark_edge_actions
		send_config_edge
		benchmark_applications
	fi	
	
	if [ "$environment" == "-b" ]; # cloud/edge
	then			
		benchmark_both_actions
		send_config_edge
		send_config_cloud
		benchmark_applications
	fi	
	
	cat $metrics_verbose_filename.txt | tr -s '[:blank:]' ',' > $metrics_verbose_filename.csv
	
	#mv $verbose_filename.txt results/
	#mv $metrics_verbose_filename.txt results/
	#mv $metrics_verbose_filename.csv results/

}

# expect user input for displaying helphelp
while getopts :h: opt; do
    case "$opt" in
        h)
            HELP
            exit 2
            ;;	
        ?)
            HELP
            exit 2
            ;;
    esac
done

main
