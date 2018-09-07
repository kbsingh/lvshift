#!/bin/bash

yum -y install wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum -y install epel-release centos-release-openshift-origin
yum -y install openshift-ansible docker origin-clients

# dont want epel bits to sneak into the cluster bringup itself
yum-config-manager --save --disablerepo=epel

sed -ie "s/OPTIONS='--selinux-enabled/OPTIONS='--insecure-registry 172.30.0.0/16 --selinux-enabled/" /etc/sysconfig/docker
systemctl start docker

# may want to setup docker-storage


ansible-playbook -i localhost.inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
if [ $? -eq 0 ]; then
  ansible-playbook -i localhost.inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
fi
