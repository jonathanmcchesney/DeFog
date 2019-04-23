# DeFog Codebase

This subfolder contains the fog applications integrated within DeFog to perform containerised benchmarks on the Cloud and Edge:

* `assets` - Fog application specific workload asset files
* `configs` - Template configuration file and .pem file
* `dockerScripts` - Template docker build, run, execute and dockerfile scripts.
* `jmeter` - JMeter build/ directory location
* `results` - Results destination folder
* `tests` - A selection of manual acceptance and assertion test scripts/files
* `utilityScripts` - Template scripts used throughout DeFog


This sub folder also contains the main DeFog code base:

* `actions.sh` - Used to execute platform benchmarks and building applications
* `applications.sh` - Used to execute fog application benchmarks
* `defog.sh` - Used to calculate metrics, and communicate with Cloud and Edge platform instances.
* `defogexecute.sh` - Accepts user input, provides command line interaction and help/FAQ functionality.
