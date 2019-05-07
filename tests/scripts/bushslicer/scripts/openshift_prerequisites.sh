#!/bin/bash
sudo yum install -y yum-utils &&

### ARCH SWITCH ###
arch=$(arch)
case $arch in

"x86_64" )
basedir=server
;;

"ppc64le" )
basedir=power-le
;;

esac

if [ -z "$basedir" ] || [ -z "$arch" ]; then
  echo "Error: Invalid base repo directory=[$basedir] or arch=[$arch]"
  exit 1
fi

# Install repos
sudo rpm --import https://www.redhat.com/security/data/fd431d51.txt
sudo yum-config-manager --add-repo http://pulp.dist.prod.ext.phx2.redhat.com/content/dist/rhel/$basedir/7/7Server/$arch/os/ &&
sudo yum-config-manager --add-repo http://pulp.dist.prod.ext.phx2.redhat.com/content/dist/rhel/$basedir/7/7Server/$arch/optional/os/ &&
sudo yum-config-manager --add-repo http://pulp.dist.prod.ext.phx2.redhat.com/content/dist/rhel/$basedir/7/7Server/$arch/extras/os/ &&
sudo yum-config-manager --add-repo http://pulp.dist.prod.ext.phx2.redhat.com/content/dist/rhel/$basedir/7/7Server/$arch/ansible/2/os/ &&
sudo yum-config-manager --add-repo http://pulp.dist.prod.ext.phx2.redhat.com/content/dist/rhel/$basedir/7/7Server/$arch/rhscl/1/os/

# Install Ansible
sudo yum install -y ansible

echo -e "\n\n\nPLAYBOOK START :: INSTALL & CONFIGURE OPENSHIFT INSTALLER\n\n\n" &&
    ansible-playbook -i localhost.inventory configure-openshift.yml &&

echo -e "\n\n\nPLAYBOOK START :: INSTALL PREREQUISITES\n\n\n" &&
    ansible-playbook -i artifacts/host.inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
