# HOW TO USE:
At the root level is a Pipfile. Initiate a pipenv with `pipenv install && pipenv shell` to load environment variables

terraform commands are run from within the ansible folder

e.g. `ansible-playbook playbooks/terraform-plan.yml`

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
