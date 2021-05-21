# ansible version > 2.9

How to deploy:
1) set hosts file (hosts)

set all host to vms group
set master host to master
set slave host to slave

example:  
[vms]  
192.168.2.40  ansible_ssh_user=root ansible_ssh_pass="root123"  
192.168.2.41  ansible_ssh_user=root ansible_ssh_pass="root123"  
192.168.2.42  ansible_ssh_user=root ansible_ssh_pass="root123"  
[master]  
192.168.2.40  ansible_ssh_user=root ansible_ssh_pass="root123"  
[slave]  
192.168.2.41  ansible_ssh_user=root ansible_ssh_pass="root123"  
192.168.2.42  ansible_ssh_user=root ansible_ssh_pass="root123"  

2) set vars file (vars.yml)

set cdm_repo #cdm package url  
set cdm_branch #AB/HW  
set cdm_cluster_vip  
set cdm_db_vip  
set disk_device  
set lvm_device   
set fstype   

example:  
cdm_repo: "ftp://ftp-ab.aishu.cn/FTP/ci-jobs/AB7.0StorageTest/package/AnyBackupServer/ABNormal/Linux_el7_x64/Linux_el7_x64-latest.tar.gz"  
cdm_branch: AB  
cdm_cluster_vip: 192.168.2.55  
cdm_db_vip: 192.168.2.56  
cdm_device:  
    - {device: "/dev/vdb", number: "1"}  
    - {device: "/dev/vdc", number: "1"}  
    - {device: "/dev/vdd", number: "1"}  
cdm_lvm_device:  
    - {srcpath: "/dev/vg01/lv01", destpath: "/vol1", vgname: "vg01", pdevice: "/dev/vdb1"}  
    - {srcpath: "/dev/vg02/lv01", destpath: "/vol2", vgname: "vg02", pdevice: "/dev/vdc1"}  
    - {srcpath: "/dev/vg03/lv01", destpath: "/vol3", vgname: "vg03", pdevice: "/dev/vdd1"}  
cdm_fstype: xfs  

3)install cdm to all server  
ansible-playbook -i hosts cdm.yml -T 30  

4)uninstall cdm  
ansible-playbook -i hosts cdm.yml -T 30 --tags=uninstall  



