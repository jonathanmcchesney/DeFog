#!/bin/bash

rm /mnt/results/cloudresult.txt
rm /mnt/results/arrresult.txt

source /mnt/configs/config.sh

cloudaddress1="${cloudaddress/$'\r'/}"
clouduser1="${clouduser/$'\r'/}"
edgeawskey1="${edgeawskey/$'\r'/}"

cloudaddress2="${cloudaddress1/$'\n'/}"
clouduser2="${clouduser1/$'\n'/}"
edgeawskey2="${edgeawskey1/$'\n'/}"

cd ~/Experiments/Aeneas/aeneas

chmod 400 /mnt/configs/csc4006awskey.pem
export PYTHONIOENCODING=UTF-8

metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

start=$(date +%s.%N)
	# python receiver.py yolov3-tiny.weights
	scp -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/fogbench/assets/aeneas-assets/text/ ./
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Cloud Transfer: completed in $runtime secs" | tee -a results.txt

cp ./text/p001.xhtml ./text/aeneastext.xhtml
mv ./text/aeneastext.xhtml /mnt/assets/

start=$(date +%s.%N)
python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     /mnt/assets/aeneastext.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Computation: completed in $runtime secs" | tee -a results.txt

metricsValues[1]=$runtime

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python s3Upload.py map.smil aeneeas-map.smil
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

metricsValues[2]=$runtime

cat results.txt >> /mnt/results/cloudresult.txt
echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

exit

