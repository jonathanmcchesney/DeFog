
FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	git

RUN \
	apt-get install -y \
	wget 

RUN \
	git init && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/Aeneas/bothcloudaeneas/ >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
# defaults command
CMD ["scripts/execute.sh"]
