#
# Module manifest for module 'sso-api-v2'
#

@{
RootModule = 'sso-api.psm1'
ModuleVersion = '1.0'
GUID = '34f38943-e532-4977-b814-8e60a453160c'
DefaultCommandPrefix = 'SSO'
FunctionsToExport = @(
    "New-ObjectPath",
    "ConvertFrom-ObjectPath",
    "ConvertTo-ObjectPath",

    "Join-ChildPath",

    "Join-LinkPath",
    "ConvertFrom-LinkPath",

    "Join-AttributePath",
    "ConvertFrom-AttributePath",

    "New-Context",
    "Remove-Context",

    "New-Logon",

    "Invoke-Api",

    "ConvertTo-Object",
    "Get-Object",
    "Set-Object",
    "Add-Object",
    "Remove-Object",

    "Get-Child",
    "Set-Child",
    "Remove-Child",

    "ConvertTo-Link",
    "Get-Link",
    "Select-Link",
    "Set-Link",
    "Add-Link",
    "Remove-Link",

    "Get-Attribute",
    "Set-Attribute",
    "Add-Attribute",
    "Remove-Attribute"
)
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
NestedModules = @(
    "Get-CallerPreference.ps1",
    "context.ps1",
    "logon.ps1",
    "sso-path.ps1",
    "object.ps1",
    "child.ps1",
    "link.ps1",
    "attribute.ps1",
    "sso-api.psm1",
    "../oauth2/oauth2.psd1"
    "../oauth2/querystring/querystring.psd1"
)
}
