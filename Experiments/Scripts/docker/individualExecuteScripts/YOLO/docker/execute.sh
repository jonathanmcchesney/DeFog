#!/bin/bash

# remove result files
rm /mnt/results/cloudresult.txt
rm /mnt/results/arrresult.txt

# navigate to yolo application folder, change restrictions on the darknet folder
cd ~/Experiments/YOLO/yolo
chmod 777 darknet

# instantiate metricsValues
metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

# capture the time taken for computation
start=$(date +%s.%N)
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee -a results.txt

# set execution time metric
metricsValues[1]=$runtime

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

# capture time it takes to transfer to the S3 bucket
start=$(date +%s.%N)
python s3Upload.py predictions.png predict.png
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

# set upload time metric
metricsValues[2]=$runtime

# save data to the results file(s) and move results/data to relevant folder
cat results.txt >> /mnt/results/cloudresult.txt
echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

cp ./predictions.png ./returnedasset.png
mv ./returnedasset.png /mnt/results/

exit
