# Barracuda CloudGen Access - Azure Templates

![Barracuda CloudGen Access](./misc/cga-logo.png)

Azure Resource Manager (ARM) templates for CloudGen Access resources

Visit the [Site](https://www.barracuda.com/products/cloudgen-access)

Check the [Product Documentation](https://campus.barracuda.com/product/cloudgenaccess/doc/93201218/overview/)

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

  [![Deploy To Azure](./misc/deploytoazure.svg?sanitize=true)](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/barracudanetworks.barracuda-cga-proxy?tab=Overview)

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

## Links

- More deploy options:
  - [AWS Templates](https://github.com/barracuda-cloudgen-access/aws-templates)
  - [Helm Charts](https://github.com/barracuda-cloudgen-access/helm-charts)
  - [Terraform Modules](https://github.com/barracuda-cloudgen-access/terraform-modules)
- [Azure Development resources](./development.md)

## License

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0), a OSI-approved license.

## Disclaimer

All of the source code on this repository is provided "as is", without warranty of any kind,
express or implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. in no event shall Barracuda be liable for any claim,
damages, or other liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the source code.
