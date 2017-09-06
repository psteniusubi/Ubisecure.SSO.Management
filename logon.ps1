Import-Module "oauth2" -Scope Local

function New-Logon {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$true)] [PSTypeName("OAuth2.ClientConfig")] $Client,
        [parameter()] [string] $Uri = "https://localhost",
        [parameter()] [string] $ManageUri = $Uri,
        [parameter(ParameterSetName="Password")] [pscredential] $Credential,
        [parameter(ParameterSetName="Code")] [switch] $Code,
        [parameter(ParameterSetName="Code")] [allownull()] [string] $Username
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $local:scope = Get-OAuthScopeFromHttpError -Uri "$ManageUri/sso-api/site" -ErrorAction Stop
    }
    Process {
        if($Code) {
            $local:c = Get-OAuthAuthorizationCode -Authority "$Uri/uas" -Client $Client -Scope $local:scope -Username $Username
            $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $Client -Code $local:c 
        } else {
            $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $Client -Scope $local:scope -Credential $Credential
        }
        New-Context -BaseUri "$ManageUri/sso-api" -Bearer $local:bearer
    }
}
