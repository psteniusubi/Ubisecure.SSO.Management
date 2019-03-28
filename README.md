# PowerShell bindings for Ubisecure SSO Management API

Depends on [Ubisecure.OAuth2](../../../Ubisecure.OAuth2)

## Example

```powershell
New-OAuthClientConfig -Name "example.ubidemo.com.json" | New-SSOLogon -Uri "https://login.example.ubidemo.com" -ManageUri "https://manage.example.ubidemo.com" -Browser "default"

Get-SSOObject -Type "site" "System"
```
