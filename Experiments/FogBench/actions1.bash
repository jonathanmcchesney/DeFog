#!/bin/bash

# run simple benchmarks for the current running platform to generate CPU, network and IO statistics
function simple_benchmark {

    today=$(date +"%m/%d/%Y")
	echo "Starting Simple benchmarks..."
    
	simple_CPU_benchmark

    simple_IO_benchmark

	simple_network_benchmark
	
	displayInfo | tee -a $filename.txt

}

# format information to display on screen to the user
function displayInfo {
cat <<INFO

	Run Date: $today 
	*********************************
	CPU Model Name: $cpuNume
	Number of Cores: $cpuCores
	CPU Frequency: $cpuFrequency MHz
	System Uptime: $sysUptime
	Small Weights dl speed: $smallWeights
	Large Weights dl rate: $downloadTest
	Sys I/O Rate: $inputOutput
	*********************************

INFO
}

function simple_CPU_benchmark {
	local zippedFile=zipFile

    cpuNume=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	sysUptime=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
    cpuFrequency=$( awk -F: ' /cpu MHz/ {cpuFrequency=$2} END {print cpuFrequency}' /proc/cpuinfo )
    cpuCores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	
	echo -n "Benching System CPU..."
    dd if=/dev/urandom of=$zippedFile bs=1024 count=20000 >>/dev/null 2>&1
	echo -n "Unzipping small weights file ..."
    smallWeights=$( (/usr/bin/time -f "%es" tar cfj $zippedFile.bz2 $zippedFile) 2>&1 )
    rm -f zipFile*
    echo DONE
		
}

function simple_IO_benchmark {
    local benchmarkFile=benchmarker__$$

	echo -n "Benching System Input & Output ... "
    inputOutput=$( ( dd if=/dev/zero of=$benchmarkFile bs=64k count=16k conv=fdatasync && rm -f $benchmarkFile ) 2>&1 | awk -F, '{inputOutput=$NF} END { print inputOutput}' )
    echo DONE
}

function simple_network_benchmark {
	echo -n "Benching network download speed, downloading large weights file... "
    downloadTest=$( _downloadTest https://pjreddie.com/media/files/yolov3.weights )
    echo DONE
}

function _downloadTest {
	local start=$(date +%s.%N)

    wget -O /dev/null "$1" 2>&1 | awk '/\/dev\/null/ {downloadRate=$3 $4} END {gsub(/\(|\)/,"",downloadRate); print downloadRate}' | tee -a $filename.txt
	local end=$(date +%s.%N)
	local runtime=$( echo "$end - $start" | bc -l )
		
	echo Download test: completed in $runtime secs | tee -a $filename.txt
}


function download_benchmark {
    echo -n "Downloading file(s) from $1 ... "
    _downloadTest "$2"
}

function downloads_benchmark {
    echo-n "Downloading weights files ... "

    download_benchmark "yolov3 weights" \
        https://pjreddie.com/media/files/yolov3.weights

    download_benchmark "tiny weights" \
		https://pjreddie.com/media/files/tiny.weights

}

function instantiate_file {
    echo -n Creating file ...
	local start=$(date +%s.%N)
    dd if=/dev/urandom of=large_file bs=1024 count=102400
    echo OK
	local end=$(date +%s.%N)
	local runtime=$( echo "$end - $start" | bc -l )
		
	echo Create large file speed: completed in $runtime secs | tee -a $filename.txt
	
	remove_file
}

function remove_file {
	echo -n Removing file ...
	local start=$(date +%s.%N)
	rm large_file
    echo OK
	local end=$(date +%s.%N)
	local runtime=$( echo "$end - $start" | bc -l )
		
	echo Remove large file speed: completed in $runtime secs | tee -a $filename.txt
}

function install_unixbench {
    test -d UnixBench && return
    apt-get install build-essential

    local file_ver=UnixBench5.1.3
	echo "Getting UnixBench..."
 	wget -N https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/teddysun/UnixBench5.1.3.tgz
	tar xvfz $file_ver.tgz
}

function install_sysbench {
    test -d sysbench && return
	sudo apt-get install sysbench
}

function benchmark_unixbench {
    install_unixbench

    pushd UnixBench > /dev/null
    ./Run index 
    popd > /dev/null | tee -a $filename.txt
}

function benchmark_sysbench {
    echo -n Installing sysbench...

	install_sysbench
	
	echo -n Benchmarking using sysbench...
	sysbench --test=cpu --cpu-max-prime=20000 run | tee -a $filename.txt
}

function remove_docker_images_and_containers {
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
	docker rmi $(docker images -q)
}

function remove_docker_containers {
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
}

function delete_utility {
    echo Deleting cleanup files ...
    rm -f large_file
	rm -f benchmarker__*
    rm -rf zipFile*
	rm -rf UnixBench*
	rm -rf yolobuild
	rm -rf bothcloudyolobuild
	rm -rf bothedgeyolobuild
	rm -rf bothcloudpsphinxbuild
	rm -rf bothedgepsphinxbuild
	rm -rf bothcloudaeneasbuild
	rm -rf bothedgeaeneasbuild
	rm -rf psphinxbuild
	rm -rf ipokemonbuild
	rm -rf aeneasbuild
	rm -rf foglampbuild
	rm -rf assets
    echo OK
	
	echo Removing docker containers and images...
		remove_docker_images_and_containers &>/dev/null
	echo OK
}

function build_docker_app_always {	

	eval buildpath = "$1"
	eval buildname = "$2"
	eval applicationname = "$3"
	
	echo Entering ${buildname}...
	mkdir ${buildname}
	cd ${buildname}

	echo Pulling down ${applicationname} docker file...
	sudo git init 
	sudo git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git
	sudo git config core.sparsecheckout true
	echo ${buildpath} >> .git/info/sparse-checkout
	sudo git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
	echo ${buildpath}...
	cd ${buildpath}

	echo Building ${applicationname} docker image...
	chmod 777 execute.sh
	time . build.sh 
	echo DONE
	
}

function build_docker_app {

	eval buildpath = "$1"
	eval buildname = "$2"
	eval applicationname = "$3"

	local DIRECTORY=${buildname}

	if [ ! -d "$DIRECTORY" ]; 
	then
		echo Entering ${buildname}...
		mkdir ${buildname}
		cd ${buildname}

		echo Pulling down ${applicationname} docker file...
		sudo git init 
		sudo git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git
		sudo git config core.sparsecheckout true
		echo ${buildpath} >> .git/info/sparse-checkout
		sudo git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
		
		echo ${buildpath}...
		cd ${buildpath}

		echo Building ${applicationname} docker image - console logs suppressed...
		echo Please wait as this may take a few minutes...
		chmod 777 execute.sh
		time . build.sh
		echo DONE	
	fi
	
}

function HELP {
    cat <<HELP
Help: benchmarker [OPTION...]

-a Benchmark all processes
-c Benchmark YOLO
-d Benchmark only small and large weight downloads
-f Create large weights file
-s Run sysbench CPU benchmark
-u Run UnixBench
-x Delete temporary files
HELP
}

function seperator {
echo -e "*****************************************************************************" | tee -a $filename.txt
}

function benchcloudinstance {

	echo "Cloud/Edge - Cloud actions and system benchmarks: " | tee $filename.txt
	seperator
	test $run_yolo && build_docker_app "Experiments/YOLO/bothclouddocker/" "bothcloudyolobuild" "YOLO-Cloud/Edge-Cloud-instance"
	test $run_psphinx && build_docker_app "Experiments/PocketSphinx/bothclouddocker/" "bothcloudpsphinxbuild" "PocketSphinx-Cloud/Edge-Cloud-instance"
	test $run_aeneas && build_docker_app "Experiments/Aeneas/bothclouddocker/" "bothcloudaeneasbuild" "Aeneas-Cloud/Edge-Cloud-instance"
	
}

function benchedgeinstance {
	
	echo "Cloud/Edge - Edge actions and system benchmarks: " | tee $filename.txt
	seperator
	test $run_yolo && build_docker_app "Experiments/YOLO/bothedgedocker/" "bothedgeyolobuild" "YOLO-Cloud/Edge-Edge-instance"
	test $run_psphinx && build_docker_app "Experiments/PocketSphinx/bothedgedocker/" "bothedgepsphinxbuild" "PocketSphinx-Cloud/Edge-Edge-instance"
	test $run_aeneas && build_docker_app "Experiments/Aeneas/bothedgedocker/" "bothedgeaeneasbuild" "Aeneas-Cloud/Edge-Edge-instance"
	
}

function bench {
	if [ "$run_cloud" ]
	then
		echo "Cloud actions and system benchmarks: " | tee $filename.txt
	else
		echo "Edge actions and system benchmarks: " | tee $filename.txt
	fi
	seperator

	test $run_simple && simple_benchmark
	test $run_downloads && downloads_benchmark
	test $run_lfile && instantiate_file
	test $run_sysbench && benchmark_sysbench
	test $run_unixbench && benchmark_unixbench
	
	test $run_yolo && build_docker_app "Experiments/YOLO/docker/" "yolobuild" "YOLO"
	test $run_psphinx && build_docker_app "Experiments/PocketSphinx/docker" "psphinxbuild" "PocketSphinx"
	test $run_aeneas && build_docker_app "Experiments/Aeneas/docker/" "aeneasbuild" "Aeneas"
	test $build_ipokemon && build_docker_ipokemon "Experiments/iPokeMon/docker/" "ipokemonbuild" "iPokeMon"
	test $run_foglamp && build_docker_app "Experiments/FogLAMP/docker/" "foglampbuild" "FogLAMP"

}

function run_setup {
	#mkdir -p fogbench && cd fogbench 
	mkdir -p defog && cd defog 		
	test $run_delete && delete_utility
	
	rm results.txt
	rm -rf dir assets && mkdir assets && chmod 777 assets
	rm -rf dir results && mkdir results && chmod 777 results
	rm -rf dir configs && mkdir configs && chmod 777 configs
}

# actions main
function main {
	run_setup
	
	# remove_docker_containers
	test $run_remove_containers && remove_docker_containers
			
	test $run_cloud && bench
    test $run_edge && bench
	test $run_both_cloud && benchcloudinstance
    test $run_both_edge && benchedgeinstance
	
	mv $filename.txt results/results.txt
}

# accept user input passed by defog bash file
while getopts :cebz:adfsxluhngs:yijpmk opt; do
    case "$opt" in
        a)
            run_downloads=true
		    run_unixbench=true
			run_sysbench=true
			run_simple=true
            ;;
		c)
			run_cloud=true
			;;
		b)
			run_both_edge=true
			;;
		e)
			run_edge=true
			;;
        d)
            run_downloads=true
            ;;
        f)
            run_lfile=true
            ;;
		s) 	
			run_sysbench=true
			;;
        x)
            run_delete=true
            ;;
		v)	
			run_remove_containers=true
			;;
		u)
            run_unixbench=true
            ;;
		g)	
			run_simple=true
			;;
		n)
			;;	
		z)
			run_both_cloud=true
			;;
		i)	
			build_ipokemon=true
			run_ipokemon=true
			;;
		j)	
			run_aeneas=true
			;;	
		l)	
			run_foglamp=true
			;;		
		k)	
			run_ipokemon=true
			;;	
		p)	
			run_psphinx=true
			;;	
		y)
            run_yolo=true
            ;;	
		m)
			;;
        ?)
            HELP
            exit 2
            ;;
    esac
done

main