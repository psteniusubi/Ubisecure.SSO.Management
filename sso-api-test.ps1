Import-Module "oauth2" 

$sso = "https://sso.example.com:8443"
$client = New-OAuthClientConfig -Path "C:\Projects\sso5\testing\trunk\build\ubilogin-sso\ubilogin\webapps\sso-api\WEB-INF\oauth2\client.json"

$api = "$sso/sso-api"
$scope = Get-OAuthScopeFromHttpError -Uri "$api/site" -ErrorAction Stop
$bearer = Get-OAuthAccessToken -Authority "$sso/uas" -Client $client -Scope $scope -Credential (Get-Credential -Message $sso -UserName "system")

$env:HOME | Join-Path -ChildPath "Documents\WindowsPowerShell\sso-api-v2\sso-api-v2.psd1" | Import-Module -Force 

New-SSOContext -BaseUri $api -Bearer $bearer

New-SSOObjectPath -Type "application" "System","Ubilogin" | Join-SSOAttributePath -Name "metadata" | Get-SSOAttribute -Verbose

New-SSOObjectPath -Type "site" "System" | Get-SSOObject | Get-SSOObject

New-SSOObjectPath -Type "site" "Example" | Set-SSOObject 
New-SSOObjectPath -Type "site" "Example" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink 
New-SSOObjectPath -Type "site" "Example" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink | Remove-SSOObject 
New-SSOObjectPath -Type "site" "Example" | Add-SSOObject -Type "group" -Name "users" 

New-SSOObjectPath -Type "site" | Join-SSOLinkPath -LinkName "sub" | Get-SSOLink | Get-SSOObject 

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

Join-SSOLinkPath -Path $policy -Link $users | Add-SSOLink -Attributes @{"attributename"="name";"attributevalue"="value1";} -Verbose
Join-SSOLinkPath -Path $policy -Link $users | Add-SSOLink -Attributes @{"attributename"="name";"attributevalue"="value1";} -Verbose

$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink
$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | Get-SSOObject
$policy | Join-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | Remove-SSOObject -Verbose
$policy | Join-SSOLinkPath -LinkType "group" | Get-SSOLink 
$policy | Join-SSOLinkPath -LinkType "group" | Get-SSOLink | Select-Object -ExpandProperty "Index" | Get-SSOObject 

New-SSOObjectPath -Type "method" "password.1" | Join-SSOLinkPath -LinkType "user" | Get-SSOLink | Get-SSOLink -Verbose
New-SSOObjectPath -Type "method" "password.1" | Join-SSOLinkPath -LinkType "user" | Get-SSOLink | Get-SSOObject -Verbose
