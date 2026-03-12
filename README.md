# OpenStack noris nSC Terraform Demo
This repository implements the [noris Sovereign Cloud (nSC) - OpenStack & S3 Guide](https://servicenow.noris.net/csm?id=kb_article_view&sysparm_article=KB0011715) using [terraform-provider-openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest). Every CLI command from the nSC documentation is converted to idempotent IaC.

## Usage
Create application credentials by following this [guide](https://servicenow.noris.net/csm?id=kb_article_view&sysparm_article=KB0011841). 
Please make sure to place the clouds.yaml in `~/.config/openstack/clouds.yaml`
