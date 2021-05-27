#!/bin/bash

source /root/.bashrc

ERROR(){
    /bin/echo -e "\e[101m\e[97m[ERROR]\e[49m\e[39m $@"
}

WARNING(){
    /bin/echo -e "\e[101m\e[97m[WARNING]\e[49m\e[39m $@"
}

INFO(){
    /bin/echo -e "\e[104m\e[97m[INFO]\e[49m\e[39m $@"
}

exists() {
    type $1 > /dev/null 2>&1
}


dir=$(cd `dirname $0`; pwd)
hosts=$dir/hosts
varsyml=$dir/vars.yml

#AGENTCONFIG_PATH=/var/lib/jenkins/workspace/testki01/conf
agentname=$1
agentpath=$AGENTCONFIG_PATH/$agentname

if [ ! -f $agentpath ]; then
   ERROR "agentconfigfile is not existed"
   exit 1
fi

#create ansible hosts
num=`cat $agentpath | grep vmsnum | awk -F = '{print $2}'`
ipadds=`cat $agentpath | grep vmsipadd | awk -F = '{print $2}'`
username=`cat $agentpath | grep vmsusername | awk -F = '{print $2}'`
password=`cat $agentpath | grep vmspassword | awk -F = '{print $2}'`
INFO "Generating ansible hosts file"
echo "[vms]" > $hosts
for ((i=1; i<=$num; i=i+1))
do
ip=`echo $ipadds | awk -F , '{print $'$i'}'`
echo "$ip  ansible_ssh_user=$username ansible_ssh_pass=$password" >> $hosts
done

echo "[master]" >> $hosts
for ((i=1; i<=1; i=i+1))
do
ip=`echo $ipadds | awk -F , '{print $'$i'}'`
echo "$ip  ansible_ssh_user=$username ansible_ssh_pass=$password" >> $hosts
done

echo "[slave]" >> $hosts
for ((i=2; i<=$num; i=i+1))
do
ip=`echo $ipadds | awk -F , '{print $'$i'}'`
echo "$ip  ansible_ssh_user=$username ansible_ssh_pass=$password" >> $hosts
done

#create ansbile vars
INFO "Generating ansible vars yml file"
cat /dev/null > $varsyml
text=$2
if [[ "$text" =~ "cdm_cluster_vip" ]] && [[ "$text" =~ "cdm_db_vip" ]]; then 
    echo $text | awk -F\; '{for(i=1;i<=NF;i++) print $i}' >> $varsyml
else
    ERROR "cdm_cluster_vip and cdm_cluster_vip field is required"
    exit 1
fi


/usr/local/bin/ansible-playbook  -i $hosts $dir/cdm.yml -T 30
ansible_result=$?
#echo $ansible_result

if [ "$ansible_result" == "0" ]; then
   INFO "task cdm ansible is success "
else
   ERROR "task cdm ansible is failure"
   exit 1
fi



