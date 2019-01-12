#!/usr/bin/env python

import subprocess
import datetime

a=datetime.datetime.now()
subprocess.call(["scp", "-qv", "-i", "~/Documents/csc4006awskey.pem", "./large_file", "ubuntu@ec2-54-77-174-143.eu-west-1.compute.amazonaws.com:~/fogbench/assets"])
b=datetime.datetime.now()
print (b-a)