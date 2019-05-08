#!/bin/bash
echo -e "\n\n\nPLAYBOOK START:: DEPLOY CLUSTER\n\n\n" &&
    sudo ansible-playbook -i artifacts/host.inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
