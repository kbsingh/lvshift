#!/bin/bash
name=$1

if [ `virsh list --all --name| grep -q -r "${name}$" | wc -l` -gt 0 ]; then
  virsh destroy ${name}
  sleep 5
  virsh undefine ${name} --remove-all-storage
fi
