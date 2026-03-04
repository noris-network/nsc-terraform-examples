# OpenStack noris nSC Terraform Demo
This repository implements the complete noris Sovereign Cloud (nSC) Getting Started Guide using Terraform/OpenTofu. Every CLI command from the [nSC documentation](https://servicenow.noris.net/csm?id=kb_search&query=nsc) is converted to idempotent IaC.

## Features Implemented

- ✅ Complete Network Stack: examplenetwork → Router → External Gateway
- ✅ Security Groups: SSH + HTTP Loadbalancer
- ✅ Boot-from-Volume: SCS-1V-2 + Debian 12 + rbd_fast (50GB)
- ✅ Floating IPs: VM + Loadbalancer Public Access
- ✅ OVN Loadbalancer: noris native (no Octavia/Amphora)
- ✅ Volume Attach: Extra 10GB rbd_fast (hotplug, no VM destroy)
- ✅ noris-specific: SCS Flavors, rbd_fast, nbg region
