# CSC4006 - Research & Development Project

Jonathan McChesney (MEng Computer Games Development)

This repository contains:
* `Experiments`: Modified fog applications and the main DeFog codebase.
* `Minutes`: Weekly meeting minutes with supervisor Blesson Varghese.

# DeFog: 
## Demystifying Fog System Interactions Using Container-based Benchmarking

### How to Run
navigate to the DeFog folder:
```$ sh defog .```

### How to View Help
navigate to the DeFog folder:
```$ sh defog -?```

### How to run iPokeMon JMeter
* First build the docker image and container, use `$ . enter` to manually enter the container
* Navigate to the Cloud-Server using `$ cd Experiments/iPokeMon/ipokemon/Application/iPokeMon-CloudServer/`
* Start up the server `$ . runCloud.sh`, and use `crtl-c` to return from console output
* Enter `ctrl-p and ctrl-q` to detach container
exit back to the user device

### User Device Dependencies
* Install `bc`
* Ensure the latest version of bash is installed
* Install the latest version JMeter to the JMeter folder, a template structure is provided, but this may not be compatible with the edge devices local java version etc. Ensure the version of JMeter installed has the ApacheJMeter.jar within the bin folder. As of April 2019, the latest version of JMeter may not have the Jar file, use apache-jmeter-2-6 in this case. As such, the contents of this folder can be overwritten with the newest version of JMeter running Java 8.
* Ensure JMeter user and system path/environment variables are set up (JAVA_HOME and PATH). Defog has been using `jdk1.8.0_101` and `jdk1.8.0_102`.
```
Include a JAVA_HOME path variable, with value C:\Program Files\Java\jdk1.8.0_181 (or the latest version of JAVA 8 jdk/jre)
Append C:\Users\jmcch\AppData\Local\Taurus\bin, C:\Program Files (x86)\Common Files\Oracle\Java\javapath and C:\Program Files\Java\jdk1.8.0_181 to the system and user variables
```

If `Files/Java/jdk1.8.0_102/bin/java: No such file or directory` appears, this means the path/user variables are not set up correctly for JMeter, please consult the Apache JMeter documentation to fix this issue.

* Install `Taurus` bzt
* Update the configuration file `DeFog/configs/config.sh` is updated to the relevant values.
* Update the reference to the configuration folder/file(s) at the top of the defog.sh script. The default value is `~/Documents/configs`, update to the new location.
Using root access allows elevated permissions, e.g. root@123.123.12 etc. Ensure DeFog can use SSH without prompting for user interaction, e.g. entering a password. If prompted to enter a password consult ssh password-less documentation. If its the first time use, the terminal may prompt to add the address to known hosts, which is populated in the user device (or edge nodes) .ssh folder.
* Use putty to create a .pem file and update the awsemptykey.pem
* Use putty or keygen to create a ssh keys
```
$ ssh-keygen
// copy to authorized keys - should now allow ssh without prompting a password
root@123.123.12
```
* Update the .aws folder and  create a ```config``` file and add the region: 
```
[default]
region = eu-west-1
```
* Update the .aws folder and  create a ```credentials``` file and add the iam users aws_access_key_id and secret_aws_access_key_id: 
```
[default]
aws_access_key_id = XXXX
aws_secret_access_key = YYYY
```
* Update the .ssh folder with the devices id_rsa and id_rsa.pub ssh keys
Creating a ssh key documentation: ```https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-windows```

If an issue us thrown regarding '\r' line endings, this is due to GitLab automatically converting line endings LF to CRLF, this can mitigated by updating the config and adding a gitattributes file: `$ git config --global core.eol lf`. The line endings should be Unix (LF), consult git documentation to update the local git attributes to ensure the correct line endings are used.
```
* text=auto
*.txt text
*.c text
*.h text
*.jpg binary
```


If an error is thrown when connecting to the Cloud instance this is likely due to the .aws folder's contents not being set up correctly, ensure the IAM user created has the necessary priviliges/authentication to remotely access the EC2 instance and the keys are added in the format above. If the issue persists then it may be benefical to consult the AWS documentation regarding remotely accessing an EC2, as this will outline the individual steps required to set up the .aws folder.

If an issue is thrown when using secure shell to connect to the Edge or Cloud, then ensure the .ssh folder has been set up correctly. This should contain the public and private ssh keys generated. Authorized keys and known_hosts will be populated to this folder over time.

### Cloud Platform
* DeFog has been tested using an AWS EC2 ubuntu 18.04 instance, located in Dublin, Ireland. As well as an AWS S3 bucket.
* Create an AWS account and create an IAM user with the necessary privileges.
* Create an EC2 instance and S3 bucket. Assign the name `csc4006benchbucket` to the bucket.
* Update the local .ssh and .aws with the IAM users credentials (secret access keys) on the user device and Edge Nodes.

If issues arise when setting up IAM users or updating the ssh or aws credentials on the edge nodes and user device consult the AWS documentation: 
`https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html`

### Edge Platform
* DeFog has been tested using an Odroid XU 4 board with ubuntu 14.04 and a Raspberry Pi 3 running NOOBS Raspbian.
* Update the local .aws with the IAM users credentials on the edge Edge Nodes.
* Update the local .ssh with an `authorized_keys` file, containing the generated public rsa ssh key on the user device. Use ssh or scp to add this file to the .ssh folder.

If an error is thrown when DeFog attempts to upload the results to the S3 bucket, it is likely the .aws credentials are not set up correctly on the edge node. If necessary, ssh/scp the relevant access keys to the devices .aws folder. Ensure the .aws folder is located at root, i.e. `/root/.aws` as this is the location the docker run scripts look for.

If an error is thrown or ssh prompts a password or terminal interaction then the .ssh folder may not be set up correctly on the edge node. Ensure the the folder is located at `/root/.ssh` and contains the `authorized_keys` folder which is populated with the user devices public rsa key e.g. `ssh-rsa VVVV343BJ...`.


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


