#!/bin/bash
name=$1
dsize=$2

virt-install --name ${name} --memory 4096 --vcpus 1,cpuset=auto --disk size=${dsize},sparse=no,format=raw --network network=default --graphics=none --console pty,target_type=serial --location http://192.168.122.1/centos/7/os/x86_64 --extra-args "console=ttyS0,115200n8 serial ks=http://192.168.122.1/${name}.ks"
