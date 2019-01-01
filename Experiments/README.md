# Application Experiments

## Instructions

Within this folder exists the ```FogBench``` folder and various benchmark applications folders.

The ```FogBench``` folder contains the scripts and assets needed to execute the application benchmarks.

The ```Application``` folders contain the modified src code to be used for benchmarking on the cloud and edge, as well as a docker folder for building and running the applications.

The ```docker`` folder within each application allows the application(s) to be easily compiled on the respective platform. This is currently tested using ubuntu:18.04. To build the image run ```. build.sh```, then to run the automated process run ```. run.sh``` or to manually enter the container run ```. enter.sh```. To stop and remove all instances and containers run ```. remove.sh```.

## List of Benchmark Application

* iPokeMon
* Aeneas
* Pocket Sphinx
* YOLO