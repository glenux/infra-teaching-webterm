
# Teaching WebTerm

Easy web terminal for studients, when you have to teach system administration,
and SSH is not available, not installable or not allowed.


## Deployment

### Development / Test

    vagrant up

### Production

Adjust your environment variables in .env

    cd terraform/
    terraform plan
    terraform apply

    cd ../ansible
    ansible-playbook -i inventories/terraform playbook.yml


## Usage

Open your web browser and type the gateway IP or domain.

For development

* URL: <http://192.168.50.250>
* Password: demo

For production:

* Please use the credentials defined in `ansible/host_vars/*`

