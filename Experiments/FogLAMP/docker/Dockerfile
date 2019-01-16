
FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	bc \
	automake \
	avahi-daemon \ 
	cmake \ 
	g++ \ 
	make \
	sqlite3 \ 
	libslite3-dev \ 
	libboost-dev \ 
	libboost-system-dev \ 
	libboost-thread-dev \ 
	libpq-dev \ 
	uuid-dev \
	python-dev \ 
	python3-pip \ 
	python-dbus \
	postgresql \
	bluez \
	jq \
	git

RUN \
	pip install boto3

RUN \
	git init && \
	ls && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/FogLAMP/foglamp/ >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
RUN \
	cd Experiments/FogLAMP/foglamp/ && \
	make clean && \
	make
	
RUN \ 
	export FOGLAMP_ROOT=Experiments/FogLAMP/foglamp/ && \
	cd Experiments/FogLAMP/foglamp/ && \
	scripts/foglamp start && \
	scripts/foglamp status && \
	curl -s http://localhost:8081/foglamp/echo | jq && \
	curl -s http://localhost:8081/foglamp/statistics | jq | jq && \
	curl -s http://localhost:8081/foglamp/audit?limit=20 | jq && \
	curl -X GET http://localhost:8081/foglamp/category | jq && \
	curl -X GET http://localhost:8081/foglamp/task | jq && \
	scripts/foglamp stop
	
# defaults command
CMD ["scripts/execute.sh"]
