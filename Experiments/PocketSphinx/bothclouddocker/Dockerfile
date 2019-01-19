

FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	automake \
	git \
	gcc \
	bc \
	ffmpeg \
	bison \
	swig \
	python-dev \
	python-pip \
	libpulse-dev 

RUN \
	apt-get install -y \
	wget

RUN \
	pip install boto3
	
RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/PocketSphinx/bothcloudpsphinx/ >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master

# defaults command
CMD ["scripts/execute.sh"]
