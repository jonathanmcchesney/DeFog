

FROM ubuntu:18.04

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	tcl \
	libtool \
	python \
	python3 \
	python-pip \
	python3-pip \
	python-dev \
	git

RUN \
	apt-get install -y \
	wget
	

RUN \
	git clone https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	ls && \
	cd csc4006-EdgeBenchmarking/Experiments/iPokeMon/ipokemon/Application/iPokeMon-CloudServer && \
	mkdir logs

RUN \ 
	cd csc4006-EdgeBenchmarking/Experiments/iPokeMon/ipokemon/Application/iPokeMon-CloudServer && \
	. runCloud.sh
	


# defaults command
CMD ["bash"]
