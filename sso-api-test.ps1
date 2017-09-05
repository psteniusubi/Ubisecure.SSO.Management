Import-Module "oauth2" 

$sso = "https://sso.example.com:8443"
$client = New-OAuthClientConfig -Path "C:\Projects\sso5\testing\trunk\build\ubilogin-sso\ubilogin\webapps\sso-api\WEB-INF\oauth2\client.json"

$api = "$sso/sso-api"
$scope = Get-OAuthScopeFromHttpError -Uri "$api/site" -ErrorAction Stop
$bearer = Get-OAuthAccessToken -Authority "$sso/uas" -Client $client -Scope $scope -Credential (Get-Credential -Message $sso -UserName "system")

Import-Module "C:\Users\jeps\OneDrive\Work\sso-path\sso-api.psd1" -Force -Verbose

New-SSOContext -BaseUri $api -Bearer $bearer

New-SSOObjectPath -Type "application" -Path "System","Ubilogin" | Set-SSOAttributePath -Name "metadata" | Get-SSOAttribute -Verbose

New-SSOObjectPath -Type "site" -Path "System" | Get-SSOObject -Verbose  | Get-SSOObject

New-SSOObjectPath -Type "site" -Path "Example" | Set-SSOObject 
New-SSOObjectPath -Type "site" -Path "Example" | Set-SSOLinkPath -LinkName "sub" | Get-SSOLink | % { Remove-SSOObject -Path $_.Reference.Link -Verbose }
New-SSOObjectPath -Type "site" -Path "Example" | Add-SSOObject -Type "group" -Name "users" 

New-SSOObjectPath -Type "site" | Set-SSOLinkPath -LinkName "sub" | Get-SSOLink | % { Get-SSOObject -Path $_.Reference.Link }

Invoke-SSOApi Get (New-SSOObjectPath -Type "site" | Set-SSOLinkPath -LinkName "sub") | ConvertTo-SSOReference
Invoke-SSOApi Get (New-SSOObjectPath -Type "application" -Path "System","Ubilogin" | Set-SSOLinkPath -LinkType "method") | ConvertTo-SSOReference

Invoke-SSOApi Get (New-SSOObjectPath -Type "policy" -Path "SSO API Sample","sso-api-policy" | Set-SSOLinkPath -LinkType "group") | ConvertTo-SSOReference
Invoke-SSOApi Get (New-SSOObjectPath -Type "policy" -Path "SSO API Sample","sso-api-policy" | Set-SSOLinkPath -LinkType "policyItem") | ConvertTo-SSOReference

Invoke-SSOApi Get (New-SSOObjectPath -Type "site" -Path "System") -Verbose | ConvertTo-SSOObject
Invoke-SSOApi Get (New-SSOObjectPath -Type "site" -Path "System" | Set-SSOLinkPath -LinkName "sub" -Link (New-SSOObjectPath -Type "group")) -Verbose

Invoke-SSOApi Get (New-SSOObjectPath -Type "application" -Path "System","Ubilogin" | Set-SSOAttributePath -Name "metadata") -Verbose

$policy = New-SSOObjectPath -Type "policy" -Path "SSO API Sample","sso-api-policy" 
$users = New-SSOObjectPath -Type "group" -Path "SSO API Sample","users"
#Set-SSOLinkPath -Path $policy -Link $users | Invoke-SSOApi -Method Post -Body @{"attributename"="name";"attributevalue"="value1";} -Verbose
Set-SSOLinkPath -Path $policy -Link $users | Add-SSOLink -Attributes @{"attributename"="name";"attributevalue"="value1";} -Verbose

$policy | Set-SSOLinkPath -LinkType "policyItem" | Get-SSOLink
$policy | Set-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | % { Get-SSOObject -Path $_.Reference.Link }
$policy | Set-SSOLinkPath -LinkType "policyItem" | Get-SSOLink | % { Remove-SSOObject -Path $_.Reference.Link -Verbose }
$policy | Set-SSOLinkPath -LinkType "group" | Get-SSOLink 
$policy | Set-SSOLinkPath -LinkType "group" | Get-SSOLink | % { Get-SSOObject -Path $_.Index }
