#
# Module manifest for module 'sso-api'
#

@{
RootModule = 'sso-api.psm1'
ModuleVersion = '1.0'
GUID = '34f38943-e532-4977-b814-8e60a453160c'
DefaultCommandPrefix = 'SSO'
NestedModules = @(
    "Get-CallerPreference.psm1",
    "context.psm1",
    "sso-path.psm1",
    "sso-api.psm1",
    "object.psm1",
    "link.psm1",
    "attribute.psm1"
)
RequiredModules = @(
    #@{ModuleName=”oauth2”;RequiredVersion="1.0"},
    #@{ModuleName=”querystring”;RequiredVersion="1.0"}
)
}
