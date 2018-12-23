

FROM ubuntu:18.04

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
	gcc  \
	bison \
	swig \
	python-dev \
	libpulse-dev 

RUN \
	apt-get install -y \
	wget
	
RUN \
	git clone https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	cd csc4006-EdgeBenchmarking/Experiments/PocketSphinx/pocketsphinx/ && \
	cd sphinxbase/ && \
	./autogen.sh && \
	make && \
	make install && \
	export LD_LIBRARY_PATH=/usr/local/lib && \
	ldconfig && \
	
	cd pocketsphinx && \
	./autogen.sh && \
	make && \
	make install

RUN \ 
	cd csc4006-EdgeBenchmarking/Experiments/PocketSphinx/pocketsphinx/ && \
	cd sphinxbase/ && \
	export LD_LIBRARY_PATH=/usr/local/lib && \
	cd pocketsphinx && \
	pocketsphinx_continuous -infile b0427.wav

# defaults command
CMD ["bash"]
