#!/bin/bash

yum -y install epel-release
yum -y install centos-release-openshift-origin
yum -y install openshift-ansible
# may need docker setup and docker-storage

ansible-playbook -i localhost.inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -i localhost.inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
