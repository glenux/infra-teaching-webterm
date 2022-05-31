
# Teaching WebTerm

Easy web terminal for studients, when you have to teach system administration,
and SSH is not available, not installable or not allowed.

## Prerequisites

* For development
  * Vagrant - manage virtual machines
  * Minica - generate certificates
  * Ansible - provisionning
* For production
  * Terraform - manage provider infrastructure
  * Ansible - provisionning

## Installation

### Development / Test

    vagrant up

### Production

Adjust your environment variables in the `.env` file

    TF_VAR_gandi_key="xxxxxxxx"
    TF_VAR_ssh_private_key="$HOME/.ssh/path/to/key"
    TF_VAR_ssh_public_key="$HOME/.ssh/path/to/key.pub"
    TF_VAR_domain_name="example.com"
    ANSIBLE_HOST_KEY_CHECKING=False
    ANSIBLE_VAULT_PASSWORD_FILE="$HOME/path/to/passphrase"

And load it

    source ../.env

Then create the infrastructure:

    cd terraform/
    terraform plan
    terraform apply
    cd ..

And install everything:

    cd ansible
    ansible-playbook -i inventories/terraform playbook.yml
    cd ..

## Usage

Open your web browser and type the gateway IP or domain.

For development

* URL: <http://192.168.50.250>
* Password: demo

For production:

* Please use the credentials defined in `ansible/host_vars/*`

