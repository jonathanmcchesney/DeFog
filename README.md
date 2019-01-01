# CSC4006 - CS FogBench: Edge Benchmarking Online Games & Deep Learning Applications

## Members

* Jonathan McChesney (MEng Computer Games Development)

## Games Researched

* 360BattleShip
* ALightInTheVoid
* AncientBeast
* AR-Madness
* Barotrauma
* Bomber
* Browser-Quest
* bzflag
* freeciv-web
* galaxy
* iPokeMon (Edge Suitable)
* Koru
* Last-Colony
* minetest
* mk.js
* OpenTTD
* RISK
* space-bandits
* StackQuest
* Tanks-Of-Freedom
* vue-chess
* xonotic

## LEGACY: Cloud & Edge Based game server deployments

iPokeMon and Xonotic were chosen to be taken through to the next stage, cloud and edge server deployments:

Server instances were instantiated for iPokeMon and Xonotic, using Amazon Web Services:

```
iPokeMon AWS cloud server EC2 instance.
```

```
Xonotic AWS cloud EC2 sever instance.
```

Next these games were set up on an Odroid XU4 board.
During this process it become apparent that xonotic was not suitable for edge offload, as the server and client code bases run on the same thread and was not easily seperated.
The necessary to refactor this codebase to become edge suitable was too large for this research project, as such the project scope was expanded.

## Applications Researched

* TeaStore
* Sphinx
* Pocket Sphinx
* Yolo
* Iris
* microservices-demo
* Merlin
* Aeneas
* mozilla-DeepLearning
* Lip Reading - Cross Audio-Visual Recognition using 3D Architectures
* text-to-speech
* microservices-example-systems

## Benchmark Tools Researched

* iPerf
* UnixBench
* SysBench
* Hyperfine
* GooglePerfKit
* IBM ShadowPuppets
* VPS bench
* EdgeBench
* TailBench
* sst-benchmark (speech to text benchmark)
* Wakeword-benchmark

## CS FogBench

Detail the bencmark tool, how it can be invoked, the cloud and edge pipelines and the results

### Execute Script

Detail the execute script

### Actions Script

Detail the benchmark actions

### Applications Script

Detail the benchmark applications

## Cloud Pipeline

Detail the cloud pipeline process

## Edge Pipeline

Detail the cloud/edge pipeline process

## Yolo

Detail Yolo and the relevant benchmarks

## Pocket Sphinx

Detail Pocket sphinx and the relevant benchmarks

## Aeneas

Detail Aeneas and the relevant benchmarks

## iPokeMon

Detail iPokeMon and the relevant benchmarks

### Apache JMeter

Apache JMeter was used test requests to the iPokeMon cloud server, this was used to simulate user behaviour as a workload.

## Metrics

### RTF

### Time in flight

### Latency

### Execute Time

### Memory Usage

### System Stats

### Cost

## Repositories used

### iPokeMon:
```
https://github.com/qub-blesson/ENORM.git
```

### LEGACY: Xonotic
```
https://gitlab.com/xonotic/xonotic.git
```

### YOLO v3
```
https://github.com/AlexeyAB/darknet
```

### Aeneas
```
https://github.com/readbeyond/aeneas
```

### Pocket Sphinx
```
https://github.com/cmusphinx/pocketsphinx
```

## Acknowledgments - Papers researched:

* [1]	N. Naqvi, T. Vansteenkiste-Muylle and Y. Berbers, "Benchmarking leading-edge mobile devices for data-intensive distributed mobile cloud applications", 2015 IEEE Symposium on Computers and Communication (ISCC), 2015.
* [2]	J. Plumb and R. Stutsman, "Exploiting Google's Edge Network for Massively Multiplayer Online Games", 2018 IEEE 2nd International Conference on Fog and Edge Computing (ICFEC), 2018.
* [3]	B. Varghese, O. Akgun, I. Miguel, L. Thai and A. Barker, "Cloud Benchmarking For Maximising Performance of Scientific Applications", IEEE Transactions on Cloud Computing, pp. 1-1, 2016.
* [4]	N. Wang, B. Varghese, M. Matthaiou and D. Nikolopoulos, "ENORM: A Framework For Edge NOde Resource Management", IEEE Transactions on Services Computing, pp. 1-1, 2017.
* [5]	B. Varghese, N. Wang, S. Barbhuiya, P. Kilpatrick and D. Nikolopoulos, "Challenges and Opportunities in Edge Computing", 2016 IEEE International Conference on Smart Cloud (SmartCloud), 2016.
* [6]	X. Wei, S. Wang, A. Zhou, J. Xu, S. Su, S. Kumar and F. Yang, "MVR: An Architecture for Computation Offloading in Mobile Edge Computing", 2017 IEEE International Conference on Edge Computing (EDGE), 2017.
* [7]	T. Triebel, M. Lehn, R. Rehner, B. Guthier, S. Kopf and W. Effelsberg, "Generation of synthetic workloads for multiplayer online gaming benchmarks", 2012 11th Annual Workshop on Network and Systems Support for Games (NetGames), 2012.
* [8]	E. Cuervo, A. Balasubramanian, D. Cho, A. Wolman, S. Saroiu, R. Chandra and P. Bahl, "MAUI", Proceedings of the 8th international conference on Mobile systems, applications, and services - MobiSys '10, 2010.
* [9]	Antti P. Miettinen , Jukka K. Nurminen, "Energy efficiency of mobile clients in cloud computing", Proceedings of the 2nd USENIX conference on Hot topics in cloud computing, p.4-4, June 22-25, 2010, Boston, MA
* [10]	Shadow Puppets: Cloud-level Accurate AI Inference at the Speed and Economy of Edge
* [11]	A Benchmark for Iris Location and a Deep Learning Detector Evaluation
* [12]	EdgeBench: Benchmarking Edge Computing Platforms
* [13]	CloudRank-D: benchmarking and ranking cloud computing systems for data processing applications
* [14]	YOLO9000: Better, Faster, Stronger **
* [15] 	R-FCN: Object Detection via Region-based Fully Convolutional Networks **
* [16]	AI Benchmark: Running Deep Neural Networks on Android Smartphones **
* [17]	DAWNBench: An End-to-End Deep Learning Benchmark and Competition


