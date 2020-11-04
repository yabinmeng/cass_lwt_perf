#!/bin/bash

cd ../ansible

echo
echo ">>>> Configure recommended OS/Kernel parameters for DSE nodes <<<<"
echo
ansible-playbook -i hosts.ini os_setting.yml --private-key=~/.ssh/id_rsa_aws -u ubuntu
echo

echo
echo ">>>> Setup NoSQLBench Client <<<<"
echo
ansible-playbook -i hosts.ini nb_install.yml --private-key=~/.ssh/id_rsa_aws -u ubuntu
echo

echo
echo ">>>> Setup DSE application cluster <<<<"
echo
ansible-playbook -i hosts.ini dse_install.yml --private-key=~/.ssh/id_rsa_aws -u ubuntu
echo

echo
echo ">>>> Setup DSE OpsCenter cluster <<<<"
echo
ansible-playbook -i hosts.ini opsc_install.yml --private-key=~/.ssh/id_rsa_aws -u ubuntu

cd ../bash