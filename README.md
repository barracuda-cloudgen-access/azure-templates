# Azure Templates

Azure Resource Manager (ARM) templates for CloudGen resources

## Barracuda CloudGen Access Proxy

The template includes:

- KeyVault and strict Access policies to store Cloudgen Access Proxy token
- Load Balancer with Public IP
- Virtual Machine Scale Set stateless instances for the proxy services
  - Unhealthy instances will be automatically replaced
- Azure Cache for Redis, when more than one instances are selected
- Storage Account to store logs from instances, files are automatically removed after 7 days

### Deploy

- Azure Portal

  [![Deploy To Azure](./images/deploytoazure.svg?sanitize=true)](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/barracudanetworks.barracuda-cga-proxy?tab=Overview)

- Azure Cli (testing purposes)

  ```sh
  az deployment group create \
    --name cga-proxy \
    --resource-group cga-proxy \
    --template-file ./templates/cga-proxy/mainTemplate.json \
    -p accessProxyToken="${ACCESSPROXYTOKEN:?}" \
    -p virtualNetworkName=cga-proxy-vnet \
    -p virtualNetworkNewOrExisting=existing \
    -p virtualNetworkAddressPrefix=10.1.0.0/16 \
    -p virtualNetworkResourceGroup=cga-proxy \
    -p subnetName=default \
    -p subnetAddressPrefix=10.1.0.0/24 \
    -p templateLocation=eastus2euap \
    - virtualMachineScaleSetInstanceCount=2 \
    -p virtualMachineScaleSetAvailabilityZones=['1','2', '3'] \
    -p virtualMachineScaleSetAuthPublicKey="$(cat ~/.ssh/cga-proxy-key.pub)"
  ```

### Actions

- Check [Makefile](./Makefile)

## Azure Links

- [Create UI Definition Sandbox](https://portal.azure.com/?feature.customPortal=false#blade/Microsoft_Azure_CreateUIDef/SandboxBlade)
- [Custom deployment](https://portal.azure.com/?feature.customPortal=false#create/Microsoft.Template)
- [API Explorer](https://docs.microsoft.com/en-us/rest/api/resources/providers/get)

## DISCLAIMER

All of the source code on this repository is provided "as is", without warranty of any kind,
express or implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. in no event shall Barracuda be liable for any claim,
damages, or other liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the source code.
