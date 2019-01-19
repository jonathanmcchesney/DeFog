#!/bin/bash

rm -rf /mnt/assets/en-us

cd ~/Experiments/YOLO/bothcloudpshinx

#echo "Starting connection to edge..."
#python sender.py ./en-us
#echo "Finished sending acoustic model to Pocket Sphinx Edge!"
#echo "Closing connection to edge..."

mv ./en-us /mnt/assets/

exit
