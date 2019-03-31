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

metricsValues=("NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA")

file=$( cat /mnt/assets/aeneas.txt )
new_file="${file%%.*}"

start=$(date +%s.%N)
	# python receiver.py yolov3-tiny.weights
	# scp -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/defog/assets/aeneas-assets/text/$new_file.xhtml ./
	transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/defog/assets/aeneas-assets/text/$new_file.xhtml ./ 2>&1 | grep "Transferred") 		
	nocarriagereturns=${transfer_cloud//[!0-9\\ \\.]/}
	newarr1=(`echo ${nocarriagereturns}`);
	echo cloud to edge transfer size etc
	echo ${newarr1[@]}
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Cloud Transfer: completed in $runtime secs" | tee -a results.txt
metricsValues[9]=${newarr1[1]}
metricsValues[10]=$runtime

#cp ./p*.xhtml ./aeneastext.xhtml
#mv ./aeneastext.xhtml /mnt/assets/

start=$(date +%s.%N)
python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     ./$new_file.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil
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

cp ./map.smil ./returnedasset.smil
mv ./returnedasset.smil /mnt/results/

exit

