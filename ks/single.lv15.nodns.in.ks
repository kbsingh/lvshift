auth --enableshadow --passalgo=sha512
url --url="http://lv1.nodns.in/centos/7/os/x86_64"
text
firstboot --disable
ignoredisk --only-use=vda
keyboard --vckeymap=gb --xlayouts='gb'
lang en_GB.UTF-8

network --bootproto=static --device=eth0 --gateway=192.168.122.1 --ip=192.168.122.15 --nameserver=192.168.122.1 --netmask=255.255.255.0 --ipv6=disable
network --hostname=single.lv15.nodns.in

rootpw _root_
timezone UTC --isUtc
bootloader --location=mbr --boot-drive=vda --timeout=1
clearpart --all --initlabel
zerombr

part /boot --size=300 --fstype=ext4 
part / --size 4096 --fstype=xfs --grow

repo --name="base" --baseurl="http://lv1.nodns.in/centos/7/os/x86_64" --cost=100
repo --name="updates" --baseurl="http://lv1.nodns.in/centos/7/updates/x86_64" --cost=100
repo --name="extras" --baseurl="http://lv1.nodns.in/centos/7/extras/x86_64" --cost=100

reboot

%packages
@^minimal
@core
rsync
wget
docker
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%post

systemctl enable docker
echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" >>  /etc/sysconfig/docker

# make sure i can get in
mkdir -p /root/.ssh/
cat > /root/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUuxksSpEYw9YSJyUb3qfZOOS5WGtGdY+aYXJKgmFMG4yMEeFwfLbIdGOERKdiZq94+recS57U1+Y/cvLMB1HixvQmTE4pYOIvv9NcVqdY1shoHppJpGMe+ITWX5Aj9JSoKrPvF8CCEkGxoM8P2yXW4SvMP1KxQo/8tV5NtGS1vrE2jdPUe59wioJbXqV1z8s1kI/fsHIhxV0y0xwGVgao/zmyoqOjr+akz+H1/RxhhxK3lcPMmqe1hw/2HFqVvKH/JOdv5NvOyI5wuDzBmAm6xeSXV7/ODDjVzBB3SUHrsgzbSvPpqtoLzP4ilLGpPA14Fn3XPryI61Fj3fYxi/8mJF86Y4VEFzqW8+hXMhaul3BQXoS/vEq11ly3dwglqOK3HO/NYL8hqJqeUS+REjVweUpx7F1tQHDB7ghvdRHJbov464UsZk8Rzr64LFw1wDiduBz8pzuBWQdoIV/205MgdEXHt6228+Wuo1n2QC23u+YjDXU8/oi+E2qQbANEzAoercmYwONnASgJU5r/EwVPi0dVnxmrwdoGXg97uIXUpEmWyDStoFdLlS98s3KLjjTuCllGQXKb5Vhq1Wo9v29rTJ0swovaS+S3MnhfHiys34rOkRvY6/PRAUa+c1uUvNihWjc/FyFW1bDOtvHThVk+qHipCnn+H+oVGBsg36OjsQ== user@host

EOF
chmod 600 /root/.ssh/authorized_keys 
chmod 700 /root/.ssh

# setup docker storage
echo 'VG=vg' >> /etc/sysconfig/docker-storage-setup

# setup repos to point at localhost
rm -rf /etc/yum.repos.d/*.repo
cat > /etc/yum.repos.d/local.repo <<EOF
[os]
name=os
baseurl=http://lv1.nodns.in/centos/7/os/x86_64
enabled=1
gpg-check=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=updates
baseurl=http://lv1.nodns.in/centos/7/updates/x86_64
enabled=1
gpg-check=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=extras
baseurl=http://lv1.nodns.in/centos/7/extras/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

EOF

%end
