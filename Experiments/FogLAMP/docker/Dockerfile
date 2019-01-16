
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
	python-pip \
	python-dbus \
	postgresql \
	bluez \
	jq \
	git

RUN \
	pip install boto3

RUN \
	git clone https://github.com/foglamp/FogLAMP.git
	
RUN \
	ls && \
	export FOGLAMP_ROOT=FogLAMP/ && \
	cd FogLAMP && \
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
