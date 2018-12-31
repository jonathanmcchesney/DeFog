#!/bin/sh

cd ~/Experiments/YOLO/yolo
chmod 777 darknet
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg
echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py
/usr/bin/time python s3Upload.py predictions.png predict.png
echo "Done"
cd /mnt/assets
exit

