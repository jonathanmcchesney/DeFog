

FROM ubuntu:18.04

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	automake \
	git

RUN \
	apt-get install -y \
	wget

RUN \
	git clone https://gitlab.eeecs.qub.ac.uk/40126401/csc4006-EdgeBenchmarking.git && \
	ls && \
	cd csc4006-EdgeBenchmarking/Experiments/YOLO/yolo && \
	make

RUN \ 
	cd csc4006-EdgeBenchmarking/Experiments/YOLO/yolo && \
	wget https://pjreddie.com/media/files/yolov3-tiny.weights 
	

RUN \	
	cd csc4006-EdgeBenchmarking/Experiments/YOLO/yolo && \
	./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights data/eagle.jpg

# defaults command
CMD ["bash"]
