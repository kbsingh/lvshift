#!/bin/bash

# check were on centos7/x86_64

yum -d0 -y upgrade

yum -y install centos-release-openshift-origin
yum -y install origin-clients

# depending on your internet speeds, this can take a while
oc cluster up

