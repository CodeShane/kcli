export HYPERVISOR_IP=`hostname -I`
export PASSWORD="unix1234"
wget -O /root/.ovirtshellrc https://raw.githubusercontent.com/karmab/kcli/master/samples/ovirt/ovirtshellrc
sed -i "s/username =.*/username = admin@internal/" /root/.ovirtshellrc
sed -i "s/password =.*/password = $PASSWORD/" /root/.ovirtshellrc
sed -i "s/insecure = False/insecure = True/" /root/.ovirtshellrc
echo $PASSWORD | passwd --stdin root
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
systemctl restart sshd
ovirt-shell -E "add host --address $HYPERVISOR_IP --cluster-name Default --name `hostname -s` --root_password $PASSWORD"
sleep 120
ovirt-shell -E "add storagedomain --name vms --host-name `hostname -s` --type data --storage-type nfs --storage-address $HYPERVISOR_IP --storage-path /vms"
ovirt-shell -E "add storagedomain --name vms --parent-datacenter-name Default"
