#!/bin/sh

cd ~/Experiments/PocketSphinx/sphinxbase/ 
export LD_LIBRARY_PATH=/usr/local/lib
cd pocketsphinx/

start=$(date +%s.%N)
pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py
start=$(date +%s.%N)
python s3Upload.py result.txt psphinx-result.txt
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"
echo "Done"

exit

