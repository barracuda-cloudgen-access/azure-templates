# Azure Development resources

## Useful links

- [Create UI Definition Sandbox](https://portal.azure.com/?feature.customPortal=false#blade/Microsoft_Azure_CreateUIDef/SandboxBlade)
- [Custom deployment](https://portal.azure.com/?feature.customPortal=false#create/Microsoft.Template)
- [API Explorer](https://docs.microsoft.com/en-us/rest/api/resources/providers/get)

## ARM template test toolkit

Steps from [ARM template test toolkit](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/test-toolkit#test-parameters)

### MacOS

- Install dependencies

```sh
# Install coreutils
brew install coreutils unzip
# Install powershell
brew install --cask powershell
# Download arm-ttk module
mkdir -p ./tmp/arm-ttk
wget https://aka.ms/arm-ttk-latest -P ./tmp/arm-ttk
# Unzip arm-ttk module
unzip -o ./tmp//arm-ttk/arm-ttk-latest -d ./tmp/arm-ttk
# Start powershell
pwsh
```

```powershell
# Unlock Execution Policy
Get-ChildItem *.ps1, *.psd1, *.ps1xml, *.psm1 -Recurse | Unblock-File
# Import the module
Import-Module ./tmp/arm-ttk/arm-ttk/arm-ttk.psd1
# Set the configuration for the Azure template
${config} = $(Import-PowerShellDataFile -Path ./.github/linters/.arm-ttk.psd1)
# Run the tests
Test-AzTemplate @config -TemplatePath ./templates/cga-proxy/
```
