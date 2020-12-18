# Azure Templates

Azure Resource Manager (ARM) templates for CloudGen resources

## CGA Access Proxy

### Deploy

```sh
az deployment group create \
    --name cga-proxy \
    --resource-group cga-access-proxy-dev \
    --template-file ./templates/cga-access-proxy-template.json \
    -p virtualMachineScaleSetAuthPublicKey="$(cat ~/.ssh/azure-cga-proxy-key.pub)" \
    -p virtualMachineScaleSetVnetName=cga-access-proxy-dev-vnet
```

### Update custom data

1. Generate base64

    ```sh
    ./helpers/create-custom-data-base64.sh ./helpers/cga-access-proxy-custom-data.sh
    ```

1. Update variable `customData` value and commit result

## Linter

```sh
make lint
```
