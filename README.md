# Azure Templates

Azure Resource Manager (ARM) templates for CloudGen resources

## CGA Access Proxy

### Deploy

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

1. Generate base64

    ```sh
    ./helpers/create-custom-data-base64.sh ./helpers/cga-proxy-custom-data.sh
    ```

1. Update variable `customData` value and commit result

## Linter

```sh
make lint
```
