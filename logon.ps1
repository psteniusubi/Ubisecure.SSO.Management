Import-Module "oauth2" -Scope Local

function New-Logon {
    [CmdletBinding(DefaultParameterSetName="Password")]
    param(
        [parameter(ValueFromPipeline=$true)] 
        [PSTypeName("OAuth2.ClientConfig")] 
        $Client,

        [parameter()] 
        [uri] 
        $Uri = "https://localhost",

        [parameter()] 
        [uri] 
        $ManageUri = $Uri,
        
        [parameter(ParameterSetName="Password")] 
        [AllowNull()] 
        [pscredential] $Credential = $null,

        [parameter(ParameterSetName="EmbeddedBrowser")] 
        [Alias("Code")]
        [switch] 
        $EmbeddedBrowser,

        [parameter(ParameterSetName="Browser")] 
        [string] 
        $Browser = "default",

        [parameter(ParameterSetName="Browser")] 
        [switch] 
        $Private,

        [parameter()] 
        [allownull()] 
        [string] $Username
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $local:scope = Get-OAuthScopeFromHttpError -Uri ([uri]::new($ManageUri, "/sso-api/site")) -ErrorAction Stop
    }
    Process {
        $splat = @{
            "Authority"=[uri]::new($Uri, "/uas")
            "Client"=$Client
        }
        switch($PSCmdlet.ParameterSetName) {
            "Password" {
                if(-not $Credential) {
                    $Credential = Get-Credential -Message $Uri -UserName $Username
                }
                $local:bearer = Get-OAuthAccessToken @splat -Scope $local:scope -Credential $Credential
            }
            "EmbeddedBrowser" {
                $local:code = Get-OAuthAuthorizationCode @splat -Scope $local:scope -Username $Username -EmbeddedBrowser
                if($local:code) {
                    $local:bearer = Get-OAuthAccessToken @splat -Code $local:code
                }
            }
            "Browser" {
                $local:code = Get-OAuthAuthorizationCode @splat -Scope $local:scope -Username $Username -Browser $Browser -Private:$Private
                if($local:code) {
                    $local:bearer = Get-OAuthAccessToken @splat -Code $local:code
                }
            }
        }
        if(-not $local:bearer) { 
            Write-Error "SSO API Logon failed"
            return
        }
        New-Context -BaseUri ([uri]::new($ManageUri, "/sso-api")) -Bearer $local:bearer
    }
}
