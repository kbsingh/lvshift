#!/bin/bash

# check were on centos7/x86_64

yum -d0 -y upgrade

yum -y install centos-release-openshift-origin
yum -y install origin-clients

# looks like we need to stop selinux for now, with overlayfs
setenforce 0

iptables -I INPUT -p tcp --dport 80   -j ACCEPT
iptables -I INPUT -p tcp --dport 443  -j ACCEPT
iptables -I INPUT -p tcp --dport 8443 -j ACCEPT
iptables -I INPUT -p udp --dport 53 -j ACCEPT

# depending on your internet speeds, this can take a while
oc cluster up

