

FROM ubuntu:18.04

# working directory
WORKDIR /root

# install
RUN \
	apt-get update && apt-get install -y \
	autoconf \
        automake \
	libtool \
	build-essential \
	git

# addons
RUN \
	apt-get install -y \
	wget

# build repo
RUN \
	git clone https://github.com/AlexeyAB/darknet.git && \
	cd darknet && \
	make

# darknet rnns
RUN \ 
	wget https://pjreddie.com/media/files/tiny.weights >/dev/null 2>&1
	

# test executable
RUN \	
	cd darknet/ && \
	./darknet && \
# test yolo
	./darknet detect cfg/yolov3.cfg tiny.weights data/dog.jpg

# defaults command
CMD ["bash"]
