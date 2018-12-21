

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
	git clone https://github.com/cmusphinx/sphinxbase.git && \
	cd sphinxbase/ && \
	./autogen.sh && \
	make && \
	 make install && \
	export LD_LIBRARY_PATH=/usr/local/lib && \
	 ldconfig

RUN \
		cd sphinxbase/ && \
	git clone https://github.com/cmusphinx/pocketsphinx.git && \

	cd pocketsphinx && \
		./autogen.sh && \

	make && \
	 make install

RUN \ 
		cd sphinxbase/ && \
	export LD_LIBRARY_PATH=/usr/local/lib && \
	cd pocketsphinx && \
	pocketsphinx_continuous -infile b0427.wav

	


# defaults command
CMD ["bash"]
