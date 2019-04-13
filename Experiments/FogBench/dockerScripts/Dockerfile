
FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	bc \
	python \
	python-pip \
	git

RUN \
	apt-get install -y \
	wget 

RUN \
	pip install boto3

RUN \
	git init && \
	git remote add -f REPOSITORY.git && \
	git config core.sparsecheckout true && \
	echo PATH >> .git/info/sparse-checkout && \
	git pull REPOSITORY.git master	
	
# defaults command
CMD ["scripts/execute.sh"]
