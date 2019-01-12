#!/bin/bash

rm /mnt/results/cloudresult.txt
rm /mnt/results/arrresult.txt

source /mnt/configs/config.sh

cloudaddress="${cloudaddress/$'\r'/}"
clouduser="${clouduser/$'\r'/}"
edgeawskey="${edgeawskey/$'\r'/}"

cd ~/Experiments/YOLO/yolo
chmod 777 darknet
chmod 400 /mnt/configs/csc4006awskey.pem

metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

start=$(date +%s.%N)
	# python receiver.py yolov3-tiny.weights
	scp -i $edgeawskey $clouduser@$cloudaddress:/home/ubuntu/fogbench/assets/yolov3-tiny.weights ./
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Cloud Transfer: completed in $runtime secs" | tee -a results.txt

start=$(date +%s.%N)
	./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee -a results.txt

metricsValues[1]=$runtime

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
	python s3Upload.py predictions.png predict.png
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

metricsValues[2]=$runtime

cat results.txt >> /mnt/results/cloudresult.txt
echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

exit
