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
        
        [parameter(ParameterSetName="Credential")] 
        [pscredential] 
        $Credential,

        [parameter(ParameterSetName="RefreshToken")] 
        [System.Net.NetworkCredential] 
        $RefreshToken,

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

        [parameter(ParameterSetName="Password")] 
        [parameter(ParameterSetName="EmbeddedBrowser")] 
        [parameter(ParameterSetName="Browser")] 
        [allownull()] 
        [string] $UserName,

        [parameter(ParameterSetName="RefreshToken")] 
        [parameter(ParameterSetName="EmbeddedBrowser")] 
        [parameter(ParameterSetName="Browser")] 
        [ref] 
        $RefreshTokenOut
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
            "Credential" {
                $local:bearer = Get-OAuthAccessToken @splat -Scope $local:scope -Credential $Credential
            }
            "RefreshToken" {
                $local:bearer = Get-OAuthAccessToken @splat -Scope $local:scope -RefreshToken $RefreshToken
            }
            "Password" {
                $local:Credential = Get-Credential -Message $Uri -UserName $UserName
                if($local:Credential) {
                    $local:bearer = Get-OAuthAccessToken @splat -Scope $local:scope -Credential $local:Credential
                }
            }
            "EmbeddedBrowser" {
                $local:code = Get-OAuthAuthorizationCode @splat -Scope $local:scope -Username $UserName -EmbeddedBrowser
                if($local:code) {
                    $local:bearer = Get-OAuthAccessToken @splat -Code $local:code -RefreshTokenOut $RefreshTokenOut
                }
            }
            "Browser" {
                $local:code = Get-OAuthAuthorizationCode @splat -Scope $local:scope -Username $UserName -Browser $Browser -Private:$Private
                if($local:code) {
                    $local:bearer = Get-OAuthAccessToken @splat -Code $local:code -RefreshTokenOut $RefreshTokenOut
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
