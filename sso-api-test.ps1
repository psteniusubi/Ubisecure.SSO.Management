
$cred = [System.Net.NetworkCredential]::new("system", "admin")
$cred = [pscredential]::new($cred.UserName, $cred.SecurePassword)

New-OAuthClientConfig -Path "C:\Projects\sso5\testing\trunk\build\ubilogin-sso\ubilogin\webapps\sso-api\WEB-INF\oauth2\client.json" |
    New-SSOLogon -Uri "https://sso.example.com:8443" -Credential $cred

New-SSOObjectPath -Type "site" "System" | Invoke-SSOApi -Verbose 
New-SSOObjectPath -Type "site" "System" | Join-SSOLinkPath -LinkName "one" | Invoke-SSOApi -Verbose
New-SSOObjectPath -Type "application" "System","Ubilogin" | Join-SSOAttributePath -Name "metadata" | Invoke-SSOApi -Verbose

New-SSOObjectPath -Type "site" "System" | Invoke-SSOApi | % { $_.InnerXml }
New-SSOObjectPath -Type "site" "System" | Invoke-SSOApi | ConvertTo-SSOObject 

New-SSOObjectPath -Type "site" "System" | Join-SSOLinkPath -LinkName "one" | Invoke-SSOApi | % { $_.InnerXml }
New-SSOObjectPath -Type "site" "System" | Join-SSOLinkPath -LinkName "one" | Invoke-SSOApi | ConvertTo-SSOLink 

New-SSOObjectPath -Type "site" "System" | Get-SSOObject | Get-SSOObject

New-SSOObjectPath -Type "site" "Example" | Set-SSOObject 
New-SSOObjectPath -Type "site" "Example" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink 
New-SSOObjectPath -Type "site" "Example" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink | Select-SSOLink -Link | Remove-SSOObject 
New-SSOObjectPath -Type "site" "Example" | Add-SSOObject -ChildType "group" -ChildName "users" 

New-SSOObjectPath -Type "site" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink | Select-SSOLink -Link | Get-SSOObject 

(New-SSOObjectPath -Type "site" | Join-SSOLinkPath -LinkName "sub") | Get-Member

Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "site" | Join-SSOLinkPath -LinkName "sub") | ConvertTo-SSOLink
Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "application" "System","Ubilogin" | Join-SSOLinkPath -LinkType "method") | ConvertTo-SSOLink

Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "policy" "SSO API Sample","sso-api-policy" | Join-SSOLinkPath -LinkType "group") | ConvertTo-SSOLink
Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "policy" "SSO API Sample","sso-api-policy" | Join-SSOLinkPath -LinkType "policyItem") | ConvertTo-SSOLink

Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "site" "System") | ConvertTo-SSOObject
Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "site" "System" | Join-SSOLinkPath -LinkName "sub" -Link (New-SSOObjectPath -Type "group")) -Verbose

Invoke-SSOApi -Method Get (New-SSOObjectPath -Type "application" "System","Ubilogin" | Join-SSOAttributePath -Name "metadata") -Verbose

$policy = New-SSOObjectPath -Type "policy" "SSO API Sample","sso-api-policy" 
$users = New-SSOObjectPath -Type "group" "SSO API Sample","users"

$policy | Join-SSOLinkPath -Link $users | Add-SSOLink -Attributes @{"attributename"="name";"attributevalue"="value1";} -Verbose
$policy | Join-SSOLinkPath -Link $users | Add-SSOLink -Attributes @{"attributename"="name";"attributevalue"="value1";} -Verbose

$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink
$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | Select-SSOLink -Link | Get-SSOObject
$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | Select-SSOLink -Link | Remove-SSOObject -Verbose
$policy | Join-SSOLinkPath -LinkType "group" | Get-SSOLink 
$policy | Join-SSOLinkPath -LinkType "group" | Get-SSOLink | Select-SSOLink -Index | Get-SSOObject 

New-SSOObjectPath -Type "method" "password.1" | Join-SSOLinkPath -LinkType "user" | Get-SSOLink | Get-SSOLink -Verbose
New-SSOObjectPath -Type "method" "password.1" | Join-SSOLinkPath -LinkType "user" | Get-SSOLink | Select-SSOLink -Link | Get-SSOObject -Verbose
