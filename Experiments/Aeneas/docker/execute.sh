#!/bin/sh

cd ~/Experiments/Aeneas/aeneas

start=$(date +%s.%N)
python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     /mnt/assets/aeneastext.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"

echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py

start=$(date +%s.%N)
python s3Upload.py map.smil aeneeas-map.smil
end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Completed in $runtime seconds"
echo "Done"

exit

