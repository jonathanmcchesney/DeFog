

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
	 curl -O http://download.redis.io/redis-stable.tar.gz && \
	 mkdir redisTemp && \
	 cd redisTemp && \
	 tar xzvf ../redis-stable.tar.gz && \
	 cd redis-stable && \
	 make && \
	 make test && \
	 mkdir /etc/redis && \
	 cp /home/george/redis-stable/redis.conf /etc/redis && \
	 cp /../redis-stable/redis.conf /etc/redis && \
	 cp ../../redis-stable/redis.conf /etc/redis && \
	 cp redis.conf /etc/redis && \
	 adduser --system --group --no-create-home redis && \
	 mkdir /var/lib/redis && \
	 chown redis:redis /var/lib/redis && \
	 chmod 770 /var/lib/redis && \
	 sudo systemctl start redis && \


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
