#!/usr/bin/env bash
cloudaddress="ec2-XXX" 							# Cloud EC2 instance address
clouduser="ubuntu" 								# Cloud username e.g. IAM user ec2user1
cloudpublicip=XX.XXX.XX.XXX						# Cloud public ip address
edgeaddress1=XXX.XXX.X.XX						# Edge Node 01 ip address
edgeuser1=root									# Edge Node 01 username
edgeaddress2=XXX.XXX.X.XX						# Edge Node 02 ip address
edgeuser2=root									# Edge Node 02 username
awskey=~/Documents/configs/emptyawskey.pem 		# .pem file location on the local user device
edgeawskey=/mnt/configs/emptyawskey.pem 		# .pem file location on the Edge Node
foglampaddress="http://localhost:8081"			# foglamp localhost server addresss