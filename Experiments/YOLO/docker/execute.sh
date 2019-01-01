#!/bin/sh

cd ~/Experiments/YOLO/yolo
chmod 777 darknet

start=$(date +%s.%N)
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"


echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python s3Upload.py predictions.png predict.png
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"
echo "Done"

exit

