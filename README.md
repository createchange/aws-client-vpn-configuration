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
