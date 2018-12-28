

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
	time \
	bison \
	swig \
	python-dev \
	libpulse-dev 

RUN \
	apt-get install -y \
	wget
	
RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	ls && \
	git config core.sparsecheckout true && \
	echo Experiments/PocketSphinx/sphinxbase >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
RUN \
	cd Experiments/PocketSphinx/sphinxbase/ && \
	chmod 777 autogen.sh && \
	./autogen.sh && \
	make clean && \
	make && \
	make install && \
	export LD_LIBRARY_PATH=/usr/local/lib && \
	ldconfig && \
	
	cd pocketsphinx/ && \
	chmod 777 autogen.sh && \
	./autogen.sh && \
	make clean && \
	make && \
	make install

# defaults command
CMD ["scripts/execute.sh"]
