#!/bin/sh

cd ~/Experiments/YOLO/yolo
chmod 777 darknet
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights data/eagle.jpg
