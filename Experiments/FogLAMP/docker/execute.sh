#!/bin/bash

rm /mnt/results/cloudresult.txt
rm /mnt/results/arrresult.txt

metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

cd ~/FogLAMP
export FOGLAMP_ROOT=/root/FogLAMP

cp /mnt/assets/foglampcurlcommand.sh .

scripts/foglamp start

start=$(date +%s.%N)
# curl -s http://localhost:8081/foglamp/ping >> foglampoutput.txt
. foglampcurlcommand.sh >> foglampoutput.txt

end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee -a results.txt

scripts/foglamp stop

metricsValues[1]=$runtime

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python ~/Experiments/Scripts/s3Upload.py foglampoutput.txt foglampCurlOutput.txt
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

metricsValues[2]=$runtime

cat results.txt >> /mnt/results/cloudresult.txt
echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

cp ./foglampoutput.txt ./returnedasset.txt
mv ./returnedasset.txt /mnt/results/

exit