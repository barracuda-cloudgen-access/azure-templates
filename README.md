# Azure Templates

Azure Resource Manager (ARM) templates for CloudGen resources

## Barracuda CloudGen Access Proxy

The template includes:

- KeyVault and strict Access policies to store Cloudgen Access Proxy token
- Load Balancer with Public IP
- Virtual Machine Scale Set stateless instances for the proxy services
  - Currently limited to one instance, support for more will be added soon
- Storage Account to store logs from instances, files are automatically removed after 7 days

### Deploy

- Azure Portal

  [![Deploy To Azure](./images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbarracuda-cloudgen-access%2Fazure-templates%2Fmain%2Ftemplates%2Fcga-proxy-template.json)

- Azure Cli

  ```sh
  az deployment group create \
    --name cga-proxy \
    --resource-group cga-proxy \
    --template-file ./templates/cga-proxy-template.json \
    -p virtualMachineScaleSetAuthPublicKey="$(cat ~/.ssh/cga-proxy-key.pub)" \
    -p virtualMachineScaleSetVnetName=cga-proxy-vnet \
    -p templateCustomTags='{"Owner":"Contoso","Cost Center":"2345-324"}'
  ```

### Update custom data

- Required on change only

1. Generate base64

  ```sh
  ./helpers/create-custom-data-base64.sh ./helpers/cga-proxy-custom-data.sh
  ```

1. Update variable `customData` value and commit result

## Linter

```sh
make lint
```
