#!/bin/bash


rm /mnt/results/cloudresult.txt
rm /mnt/results/arrresult.txt

cd ~/Experiments/PocketSphinx/sphinxbase/ 
export LD_LIBRARY_PATH=/usr/local/lib
cd pocketsphinx/

metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

start=$(date +%s.%N)
pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee -a results.txt

metricsValues[1]=$runtime

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python s3Upload.py result.txt psphinx-result.txt
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

metricsValues[2]=$runtime

length=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 /mnt/assets/psphinx.wav)
  
metricsValues[5]=$length

cat results.txt >> /mnt/results/cloudresult.txt
echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

exit

