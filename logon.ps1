Import-Module "oauth2" -Scope Local

function New-Logon {
    [CmdletBinding(DefaultParameterSetName="Password")]
    param(
        [parameter(ValueFromPipeline=$true)] [PSTypeName("OAuth2.ClientConfig")] $Client,
        [parameter()] [string] $Uri = "https://localhost",
        [parameter()] [string] $ManageUri = $Uri,
        [parameter(ParameterSetName="Password")] [AllowNull()] [pscredential] $Credential = $null,
        [parameter(ParameterSetName="Code")] [switch] $Code,
        [parameter()] [allownull()] [string] $Username
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $local:scope = Get-OAuthScopeFromHttpError -Uri "$ManageUri/sso-api/site" -ErrorAction Stop
        if(-not $Code -and -not $Credential) {
            $Credential = Get-Credential -Message $Uri -UserName $Username
        }
    }
    Process {
        if($Code) {
            $local:c = Get-OAuthAuthorizationCode -Authority "$Uri/uas" -Client $Client -Scope $local:scope -Username $Username
            if($local:c) { 
                $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $Client -Code $local:c 
            }
        } elseif($Credential) {
            $local:bearer = Get-OAuthAccessToken -Authority "$Uri/uas" -Client $Client -Scope $local:scope -Credential $Credential
        }
        if(-not $local:bearer) { 
            Write-Error "SSO API Logon failed"
            return
        }
        New-Context -BaseUri "$ManageUri/sso-api" -Bearer $local:bearer
    }
}
