
FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	bc \
	python \
	python-pip \
	automake \
	git

RUN \
	apt-get install -y \
	wget 

RUN \
	pip install boto3

RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/YOLO/yolo/ >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
RUN \
	cd Experiments/YOLO/yolo && \
	make clean && \
	make
	
# defaults command
CMD ["scripts/execute.sh"]
