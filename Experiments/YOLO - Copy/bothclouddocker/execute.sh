#!/bin/bash

cd ~/Experiments/YOLO/bothcloudyolo

echo "Starting connection to edge..."
python sender.py ./yolov3-tiny.weights
echo "Finished sending weights to Yolo Edge!"
echo "Closing connection to edge..."

exit