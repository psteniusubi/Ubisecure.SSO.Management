Import-Module "oauth2" -Scope Local

function New-Logon {
    [CmdletBinding()]
    param(
        [parameter()] [string] $Uri = "https://localhost",
        [parameter()] [string] $ClientConfig,
        [parameter(ParameterSetName="Password")] [pscredential] $Credential,
        [parameter(ParameterSetName="Code")] [switch] $Code,
        [parameter(ParameterSetName="Code")] [allownull()] [string] $Username
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $local:client = New-OAuthClientConfig -Path $ClientConfig
        $local:scope = Get-OAuthScopeFromHttpError -Uri "$Uri/sso-api/site" -ErrorAction Stop
    }
    Process {
        if($Code) {
            $local:c = Get-OAuthAuthorizationCode -Authority "$Uri/uas" -Client $local:client -Scope $local:scope -Username $Username
            $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $local:client -Code $local:c 
        } else {
            $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $local:client -Scope $local:scope -Credential $Credential
        }
        New-Context -BaseUri "$Uri/sso-api" -Bearer $local:bearer
    }
}
