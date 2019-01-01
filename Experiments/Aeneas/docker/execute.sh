#!/bin/sh

cd ~/Experiments/Aeneas/aeneas
python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     /mnt/assets/aeneastext.xhtml     "task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"     map.smil
echo "Starting Upload to S3 Bucket..."
chmod 777 s3Upload.py
/usr/bin/time python s3Upload.py map.smil aeneeas-map.smil
echo "Done"
cd /mnt/assets
exit

