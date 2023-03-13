#!/bin/bash

username=$(whoami)

# check if SSH keys have already been generated for the local user
if [ ! -f /home/$username/.ssh/id_rsa.pub ]; then
    echo "SSH keys have not been generated for this user. Running ssh-keygen.."
    ssh-keygen
fi

# check if the SSH public key is already in the authorized_keys file
if grep -q "$(cat /home/$username/.ssh/id_rsa.pub)" /home/$username/.ssh/authorized_keys; then
    echo "SSH public key is already in authorized_keys."
else
    echo "SSH public key is not in authorized_keys. Running ssh-copy-id..."
    ssh-copy-id localhost
fi

echo "Running apt-get to install ansible, you may be prompted for sudo access password"

sudo apt-get install -y ansible acl
sudo rm -rf /etc/ansible
sudo ln -s /home/$username/myproject1/ansible /etc/ansible
sudo chown $username /etc/ansible
sudo chgrp $username /etc/ansible
