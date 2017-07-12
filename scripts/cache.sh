#!/bin/bash
# this will cache all the locally downloaded
# docker images to a look aside registry
# action of 'up' or 'down' as $1 and
# call it with $2 = registry. eg: 
# ./cache.sh up myreg.localdom:5000

# if its an insecure registry, you will need to have it
# setup in /etc/sysconfig/docker

# if its an insecure reg, grep /etc/sysconfig/docker
# and complain if its not setup 
reg=${2}

touch cache.lst

if [ $1 = 'up' ]; then
  for x in `docker images --format "{{.ID}}: {{.Repository}}" | grep -v ${reg} | cut -f1 -d:`; do
    docker tag $x ${reg}/cache/${x}
    docker push ${reg}/cache/${x}
    if [ `grep ${x} cache.lst | wc -l` -lt 1 ]; then
      echo ${x} >> cache.lst
    fi
  done
else
  for x in `cat cache.lst`; do
    docker pull ${reg}/cache/${x}
  done
fi
