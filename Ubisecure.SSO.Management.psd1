#
# Module manifest for module "Ubisecure.SSO.Management"
#

@{
RootModule = "Ubisecure.SSO.Management.psm1"
ModuleVersion = "1.1.0"
GUID = "34f38943-e532-4977-b814-8e60a453160c"
Author = "petteri.stenius@ubisecure.com"
Description = "PowerShell bindings for Ubisecure SSO Management API"
PowerShellVersion = "5.1"
CompatiblePSEditions = "Desktop","Core"
DefaultCommandPrefix = "SSO"
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
RequiredModules = @(
    @{"ModuleName"="Ubisecure.QueryString";"ModuleVersion"="1.3.0";"Guid"="80f2f884-f2e3-457f-b7c2-16e884ce9ba2"}
    @{"ModuleName"="Ubisecure.OAuth2";"ModuleVersion"="1.1.0";"Guid"="96e72ae8-79d7-4728-a0e0-6f4b28409460"}
)
NestedModules = @(
    "Get-CallerPreference.ps1",
    "context.ps1",
    "logon.ps1",
    "sso-path.ps1",
    "object.ps1",
    "child.ps1",
    "link.ps1",
    "attribute.ps1",
    "Ubisecure.SSO.Management.psm1"
)
}
