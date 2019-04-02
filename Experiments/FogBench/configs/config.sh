#!/usr/bin/env bash
cloudaddress="ec2-XXX"
clouduser="ubuntu"
cloudpublicip=XX.XXX.XX.XXX
edgeaddress1=XXX.XXX.X.XX
edgeuser1=root
edgeaddress2=XXX.XXX.X.XX
edgeuser2=root
awskey=~/Documents/configs/emptyawskey.pem # .pem file location on the local edge device
edgeawskey=/mnt/configs/emptyawskey.pem # .pem file location on the Edge Node
foglampaddress="http://localhost:8081"