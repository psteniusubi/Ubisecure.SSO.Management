# PowerShell bindings for Ubisecure SSO Management API

Depends on [Ubisecure.OAuth2](../../../Ubisecure.OAuth2), [Ubisecure.QueryString](../../../Ubisecure.QueryString)

## Install from github.com

Windows

```cmd
cd /d %USERPROFILE%\Documents\WindowsPowerShell\Modules
git clone https://github.com/psteniusubi/Ubisecure.SSO.Management.git
```

Linux

```bash
cd ~/.local/share/powershell/Modules
git clone https://github.com/psteniusubi/Ubisecure.SSO.Management.git
```

## Example

```powershell
$client = New-OAuthClientConfig -Json @"
{
    "redirect_uris":  [
                          "http://localhost/public"
                      ],
    "grant_types":  [
                        "authorization_code"
                    ],
    "client_id":  "public",
    "client_secret":  "public"
}
"@

New-SSOLogon -Client $client -Uri "https://login.example.ubidemo.com" -ManageUri "https://manage.example.ubidemo.com" -Browser "default"

Get-SSOObject -Type "site" "System"
```
