
FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	time \
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
	ls && \
	git remote add -f csc4006-EdgeBenchmarking https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	git config core.sparsecheckout true && \
	echo Experiments/Aeneas/aeneas/ >> .git/info/sparse-checkout && \
	git pull https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git master
	
RUN \
	cd Experiments/Aeneas/aeneas && \
	bash install_dependencies.sh && \
	pip install -r requirements.txt && \
	python setup.py build_ext --inplace && \
	python aeneas_check_setup.py
	
# defaults command
CMD ["scripts/execute.sh"]
