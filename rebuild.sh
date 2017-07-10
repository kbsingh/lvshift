#!/bin/bash
for n in lv11 lv12 lv13 lv14 ; do 
  bash scripts/find-remove.sh ${n}.nodns.in && bash scripts/create_vm.sh ${n}.nodns.in 10 &
  # give it 2 seconds to breathe
  sleep 2
done
