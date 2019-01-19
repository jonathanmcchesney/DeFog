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
        libsqlite3-dev \
        libboost-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libpq-dev \
        libssl-dev \
        uuid-dev \
        python-dev \
        python3-pip \
        python-pip \
        python-dbus \
        curl \
        postgresql \
        bluez \
        jq \
        libz-dev \
        inetutils-ping \
        git

RUN \
        pip install boto3

RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/Scripts >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master		

RUN \
        git clone https://github.com/foglamp/FogLAMP.git

RUN \
        cd FogLAMP && \
        pwd && \
        make && \
        export FOGLAMP_ROOT=/root/FogLAMP && \
		cp ~/Experiments/Scripts/* .

# defaults command
CMD ["scripts/execute.sh"]