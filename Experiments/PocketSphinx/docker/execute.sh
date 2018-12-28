#!/bin/sh

cd ~/Experiments/PocketSphinx/sphinxbase/ 
export LD_LIBRARY_PATH=/usr/local/lib
cd pocketsphinx/
pocketsphinx_continuous -infile b0427.wav -logfn /dev/null
echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py
/usr/bin/time python s3Upload.py results.txt speech.txt
echo "Done"
exit

