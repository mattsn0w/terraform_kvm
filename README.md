# Deploying KVMs with terraform
Exploring creating Ubuntu Linux KVMs on a Ubuntu Ryzen5 laptop using non-monolithic terraform.

## Ansible bootstrapping
See [Ubuntu_Hypervisor](https://github.com/mattsn0w/ubuntu_hypervisor) for bootstrapping the server. This should be done before running terraform

## Customize the .tfvars file
You should adjust this file per your environment. Most variables are fairly self-explanatory and have working examples.  

## Running terraform
`/opt/bin/terraform plan --var-file=terrform.tfvars`  

