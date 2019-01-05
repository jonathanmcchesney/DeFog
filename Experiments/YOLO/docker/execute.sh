#!/bin/sh

rm /mnt/results/results.txt
rm /mnt/results/newResults.txt

cd ~/Experiments/YOLO/yolo
chmod 777 darknet

declare -g metricsValues=('NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA')

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

echo ${metricsValues[@]} >> /mnt/results/newResults.txt

cat results.txt >> /mnt/results/results.txt

exit

