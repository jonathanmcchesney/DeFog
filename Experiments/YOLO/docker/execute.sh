#!/bin/sh

cd ~/Experiments/YOLO/yolo
chmod 777 darknet


echo "Starting YOLO detection..." | tee results.txt
start=$(date +%s.%N)
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee results.txt


echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python s3Upload.py predictions.png predict.png
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime seconds" | tee -a results.txt
cat results.txt >> /mnt/results/results.txt

exit

