docker run --rm -v /home/ubuntu/fogbench/assets:/mnt/assets -v /home/ubuntu/fogbench/results:/mnt/results -v /root/.aws:/root/.aws --name foglamp foglamp ../scripts/execute.sh