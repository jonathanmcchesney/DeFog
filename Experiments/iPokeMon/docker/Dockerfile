

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
	python \
	python-pip \
	redis \
	redis-server \
	tcl \
	git

RUN \
	apt-get install -y \
	wget
	
RUN \
	pip install redis	
	
	
RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	ls && \
	git config core.sparsecheckout true && \
	echo Experiments/iPokeMon/ipokemon >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
RUN \
	cd Experiments/iPokeMon/ipokemon/Application/iPokeMon-CloudServer && \
	mkdir logs
	. ./runCloud.sh	
	
# defaults command
CMD ["scripts/execute.sh"]
