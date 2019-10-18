# Introduction

This repository aids in creation of AWS client VPN endpoints. Most of the work happens in Ansible, where I have created templates consisting of different configuration blocks. These blocks take in a list of users as a variable, and generate the final Terraform configuration files.

The basic gist of this is as such:

#### Terraform
- CA and user certs generated and uploaded to ACM
- creation of client endpoints

#### Ansible / Python
- templates to generate Terraform config files with user list as input variable
- script to associate/disassociate all endpoints as needed
- script to pull down AWS Client VPN configs, source key and cert variables from Boto and construct working .ovpn file

# HOW TO USE:

Set AWS keys in .env file. Initiate a pipenv with `pipenv install && pipenv shell` to load environment variables.

Terraform commands are run from within the ansible folder

e.g. `ansible-playbook playbooks/terraform-plan.yml`

Terraform environment may need to be initalized.

# To Do:

- [X] create vpn endpoints
- [X] source single variable list for usernames
- [X] python script for disassociating/associating 
- [X] python script for fetching .ovpn files and appending cert and key
- [ ] ansible playbook for associating/disassociating client VPN endpoint targets?
- [ ] subnet creation with appropriate tagging
- [ ] creation of appropriate routes, etc. once associated with target network (likely python implemented in existing endpointManagement.py script)
- [ ] fix folder structure (create scripts folder, etc.)
- [ ] distribution of .ovpn config files
