# CSC4006 - Research & Development Project

Jonathan McChesney (MEng Computer Games Development)

This repository contains:
* Experiments: Modified fog applications and the main DeFog codebase.
* Minutes: Weekly meeting minutes with supervisor Blesson Varghese.

# DeFog: 
## Demystifying Fog System Interactions Using Container-based Benchmarking

### How to Run
navigate to the DeFog folder:
```$ sh defog .```

### How to View Help
navigate to the DeFog folder:
```$ sh defog -?```

### User Device Dependencies
* Install 'bc'
* Ensure the latest version of bash is installed
* Update the configuration file (DeFog/configs/config.sh) is updated to the relevant values
* Use putty to create a .pem file and update the awsemptykey.pem

### Cloud Platform
* DeFog has been tested using an AWS EC2 ubuntu 18.04 instance, located in Dublin, Ireland. As well as an AWS S3 bucket.
* Create an AWS account and create an IAM user with the necessary privileges.
* Create an EC2 instance and S3 bucket. Update the sender.py application files to the new S3 bucket name.
* Update the local .ssh and .aws with the IAM users credentials (secret access keys) on the user device and Edge Nodes.

### Edge Platform
* DeFog has been tested using an Odroid XU 4 board with ubuntu 14.04 and a Raspberry Pi 3 running NOOBS Raspbian.
* Update the local .ssh and .aws with the IAM users credentials on the edge Edge Nodes.


# Background Research
### Games Researched

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
* `iPokeMon`
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

## Initial Cloud & Edge Based game server deployments

iPokeMon and Xonotic were chosen as potentially feasible fog applications and as a result were deployed to the Cloud and Edge:

Server instances were instantiated for iPokeMon and Xonotic, using Amazon Web Services:

```
iPokeMon AWS cloud server EC2 instance & Edge Node instance.
```

```
Xonotic AWS cloud EC2 sever instance & Edge Node instance.
```

It became apparent that Xonotic was not feasible for deploying to the Edge, and as a result a larger range of fog applications were researched to determine potential applications to leverage the Edge.

## Applications Researched

* TeaStore
* Sphinx
* `PocketSphinx`
* PocketSphinx-Python
* `Yolo`
* Iris
* microservices-demo
* Merlin
* `Aeneas`
* mozilla-DeepLearning
* Lip Reading - Cross Audio-Visual Recognition using 3D Architectures
* text-to-speech
* Merlin
* microservices-example-systems
* `FogLAMP`
* iRoboticsChallenge

These applications range from microservices, deep learning, Internet of Things, speech to text engines, forced alignment and latency critical robotics applications.

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
* benchmarker
* DCBench
* LINPACK
* nench
* DAWNbench
* bench-sh-2

## System Metrics

* CPU Model Nmae
* Number of Cores
* CPU Frequency
* System Uptime
* Uzip Time
* Download eate
* System I/O

## Fog Application Metrics

* Execution Time
* Time in Flight
* S3 Transfer Time
* Results Transfer Time
* Computation Latency
* Computation Cost
* Real Time Factor
* Bytes Up Transfer
* Bytes Down Transfer
* Bytes Up Per Second
* Bytes Down Per Second
* Cloud/Edge Model Tranfer Time
* Communication Latency
* Full Computation Latency
* Full Communication Latency

## External Metrics

* Completion Rate
* Number of Threads/Users
* Response Latency
* Throughput
* Standard Deviation Response Time
* Average Latency

## Repositories used

### iPokeMon:
```
https://github.com/qub-blesson/ENORM.git
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

### FogLAMP
```
https://github.com/foglamp/FogLAMP
```

## Acknowledgments - Papers researched:

* [1] N. Naqvi, T. Vansteenkiste-Muylle and Y. Berbers,Benchmarking
leading-edge mobile devices for data-intensivedistributed mobile cloud
applications, 2015 IEEE Symposiumon Computers and Communication
(ISCC), 2015.
* [2] J. Plumb and R. Stutsman, Exploiting Googles EdgeNetwork for Massively Multiplayer Online Games, 2018IEEE 2nd International Conference on Fog and Edge Computing (ICFEC), 2018.
* [3] B. Varghese, O. Akgun, I. Miguel, L. Thai and A.Barker, Cloud
Benchmarking For Maximising Performance of Scientific Applications,
IEEE Transactions on Cloud Com-puting, pp. 1-1, 2016.
* [4] N. Wang, B. Varghese, M. Matthaiou and D.Nikolopoulos, ENORM: A
Framework For Edge NOde Re-source Management, IEEE Transactions
on Services Com-puting, pp. 1-1, 2017.
* [5] B. Varghese, N. Wang, S. Barbhuiya, P. Kilpatrick and D. Nikolopoulos,
Challenges and Opportunities in Edge Computing, 2016 IEEE International Conference on SmartCloud, 2016.
* [6] X. Wei, S. Wang, A. Zhou, J. Xu, S. Su, S. Kumar andF. Yang, MVR: An
Architecture for Computation Offloading in Mobile Edge Computing,
2017 IEEE International Con-ference on Edge Computing (EDGE),
2017.
* [7] Antti P. Miettinen , Jukka K. Nurminen, Energyefficiency of mobile
clients in cloud computing, Proceedingsof the 2nd USENIX conference
on Hot topics in cloudcomputing, p.4-4, 2010, Boston, MA.
* [8] T. Triebel, M. Lehn, R. Rehner, B. Guthier, S. Kopfand W. Effelsberg,
Generation of synthetic workloads formultiplayer online gaming benchmarks, 2012 11th AnnualWorkshop on Network and Systems Support
for Games(NetGames), 2012.
* [9] E. Cuervo, A. Balasubramanian, D. Cho, A. Wolman, S.Saroiu, R. Chandra and P. Bahl, MAUI, Proceedings of the8th international conference
on Mobile systems, applications,and services - MobiSys 10, 2010.
* [10] W. Shi, J. Cao, Q. Zhang, Y. Li, and L. Xu, Edgecomputing: Vision and
challenges, IEEE Internet Things J.,vol. 3, no. 5, pp. 637646, 2016.
* [11] Y. C. Hu, M. Patel, D. Sabella, N. Sprecher, and V.Young, Mobile edge
computingA key technology towards 5G,ETSI white paper, vol. 11, no.
11, pp. 116, 2015.
* [12] Srikumar Venugopal, Michele Gazzetti, Yiannis Gko-ufas, and Kostas
Katrinis, Shadow puppets: Cloud-level accu-rate AI inference at the
speed and economy of edge, USENIXworkshop on hot topics in edge
computing (hotedge 18), 2018.
* [13] E. Severo et al., A Benchmark for Iris Location and aDeep Learning
Detector Evaluation, 2018 International JointConference on Neural
Networks (IJCNN), 2018.
* [14] Das, Anirban & Patterson, Stacy & Wittie, Mike.(2018). EdgeBench:
Benchmarking Edge Computing Plat-forms.
* [15] Luo, Chunjie & Zhan, Jianfeng & Jia, Zhen & Wang,Lei & Lu,
Gang & Zhang, Lixin & Xu, Cheng-Zhong & Sun,Ninghui. (2012).
CloudRank-D: Benchmarking and rankingcloud computing systems for
data processing applications.Frontiers of Computer Science. 6.
* [16] J. Redmon and A. Farhadi, YOLO9000: Bet-ter, Faster, Stronger, 2017
IEEE Conference on ComputerVision and Pattern Recognition (CVPR).
* [17] Maheshwari, Sumit & Raychaudhuri, Dipankar & Seskar, Ivan &
Bronzino, Francesco. (2018). Scalability and Performance Evaluation
of Edge Cloud Systems for Latency Constrained Applications, 2018
* [18] J. Dai, Y. Li, K. He, and J. Sun. R-FCN: Object Detection via
Regionbased Fully Convolutional Networks. In NIPS, 2016.
* [19] A. Ignatov, R. Timofte, P. Szczepaniak, W. Chou, K. Wang, M. Wu,
T. Hartley, and L. Van Gool, AI Benchmark: Running Deep Neural
Networks on Android Smartphones, (2018).
* [20] C. Coleman, D. Narayanan, D. Kang, T. Zhao, J. Zhang, L. Nardi, P.
Bailis, K. Olukotun, C. R, and M. Zaharia. DAWNBench: An End-toEnd Deep Learning Benchmark and Competition. NIPS ML Systems
Workshop, 2017.
* [21] Z. Li, L. OBrien, H. Zhang and R. Cai, On a Catalogue of Metrics for
Evaluating Commercial Cloud Services, 13th International Conference
on Grid Computing, 2012, pp.164- 173.
* [22] Zhang, Wuyang, et al. Towards efficient edge cloud augmentation
for virtual reality MMOGs. Proceedings of the Second ACM/IEEE
Symposium on Edge Computing. ACM, 2017.
* [23] Jacobs, Marco C., and Mark A. Livingston. Managing latency in
complex augmented reality systems. Proceedings of the 1997 symposium
on Interactive 3D graphics. ACM, 1997.
* [24] Armbrust, Michael, et al. A view of cloud computing. Communications
of the ACM 53.4 (2010): 50-58.
* [25] M. Satyanarayanan, The emergence of edge computing, Computer, vol.
50, no. 1, pp. 3039, 2017.
* [26] F. Bonomi, R. Milito, J. Zhu, and S. Addepalli, Fog Computing and
Its Role in the Internet of Things, in Proceedings of the Workshop on
Mobile Cloud Computing, 2012, pp. 1316.
* [27] H. Kasture and D. Sanchez. Tailbench: A benchmark suite and evaluation
methodology for latency-critical applications. In IEEE International
Symposium on Workload Characterization (IISWC). IEEE, 2016.
* [28] O. Rana, M. Shaikh, M. Ali, A. Anjum and L. Bittencourt, ”Vertical
Workflows: Service Orchestration across Cloud & Edge Resources,”
2018 IEEE 6th International Conference on Future IoT and Cloud, 2018.


