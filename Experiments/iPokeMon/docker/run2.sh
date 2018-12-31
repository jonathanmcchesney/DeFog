id=`docker run --net=host --name ipokemon ipokemon ../scripts/execute.sh`


# start the container
id=`docker run -d --rm other parms image_name`
# run the command in the container
docker exec id "command to run and parms"
# copy the container log file out
docker cp id from_container_file  to_host_file 

