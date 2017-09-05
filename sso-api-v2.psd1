#
# Module manifest for module 'sso-api-v2'
#

@{
RootModule = 'sso-api.psm1'
ModuleVersion = '1.0'
GUID = '34f38943-e532-4977-b814-8e60a453160c'
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

    "Invoke-Api",

    "ConvertTo-Object",
    "Get-Object",
    "Set-Object",
    "Add-Object",
    "Remove-Object",

    "ConvertTo-Link",
    "Get-Link",
    "Set-Link",
    "Add-Link",
    "Remove-Link",

    "Get-Attribute",
    "Set-Attribute",
    "Add-Attribute",
    "Remove-Attribute"
)
DefaultCommandPrefix = 'SSO'
NestedModules = @(
    "Get-CallerPreference.ps1",
    "context.ps1",
    "sso-path.ps1",
    "object.ps1",
    "link.ps1",
    "attribute.ps1",
    "sso-api.psm1"
)
RequiredModules = @(
    #@{ModuleName=”oauth2”;RequiredVersion="1.0"},
    #@{ModuleName=”querystring”;RequiredVersion="1.0"}
)
}
