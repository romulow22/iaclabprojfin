[web]
${vm_ip}

[web:vars]
ansible_ssh_user=${vm_user}
ansible_ssh_pass=${vm_password}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'