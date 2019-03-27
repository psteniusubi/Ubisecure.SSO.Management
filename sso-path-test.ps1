Import-Module "Ubisecure.SSO.Management" -Force -Prefix ""

New-SSOObjectPath -Type "site" 
New-SSOObjectPath -Type "site" -Value "System" 
New-SSOObjectPath -Type "site" -Value "System" | Join-SSOChildPath -ChildValue "Password"
New-SSOObjectPath -Type "site" "System" | Join-SSOChildPath "Password"
New-SSOObjectPath -Type "site" "System","Password"
New-SSOObjectPath -Type "site" -Value "System" | Join-SSOChildPath -ChildType "application" "Ubilogin"

$ubilogin = New-SSOObjectPath -Type "application" -Value "System","Ubilogin"
$administrators = New-SSOObjectPath -Type "group" -Value "System","Administrators"

$ubilogin | Join-SSOLinkPath -LinkName "allowedTo"
$ubilogin | Join-SSOLinkPath -LinkName "allowedTo" -LinkType "group"
$ubilogin | Join-SSOLinkPath -LinkType "group"
$ubilogin | Join-SSOLinkPath -LinkName "allowedTo" $administrators
$ubilogin | Join-SSOLinkPath -LinkType "method" "password.1"

$ubilogin.ToString()
$ubilogin | Get-Member
$ubilogin.PSObject.TypeNames

($ubilogin | Join-SSOLinkPath -LinkName "allowedTo" $administrators).ToString()
$ubilogin | Join-SSOLinkPath -LinkName "allowedTo" $administrators | Get-Member
($ubilogin | Join-SSOLinkPath -LinkName "allowedTo" $administrators).PSObject.TypeNames

($ubilogin | Join-SSOAttributePath "metadata").ToString()
$ubilogin | Join-SSOAttributePath "metadata" | Get-Member
($ubilogin | Join-SSOAttributePath "metadata").PSObject.TypeNames

New-SSOObjectPath -Type "site" "System" | Join-SSOChildPath -ChildType "application" "Ubilogin"
New-SSOObjectPath -Type "site" "System" | Join-SSOChildPath -ChildType "group" "Authenticated Users"
New-SSOObjectPath -Type "site" "System" | Join-SSOChildPath "SSO API" | Join-SSOChildPath -ChildType "application" "SSO API"
New-SSOObjectPath -Type "application" "System","SSO API","SSO API"

$ubilogin | Join-SSOAttributePath "metadata"

$ubilogin | ConvertFrom-SSOObjectPath
$ubilogin | Join-SSOLinkPath -LinkName "allowedTo" -Link $administrators | ConvertFrom-SSOLinkPath
$ubilogin | Join-SSOAttributePath "metadata" | ConvertFrom-SSOAttributePath

$ubilogin | ConvertFrom-ObjectPath | ConvertTo-SSOObjectPath
$ubilogin | Join-SSOLinkPath -LinkName "allowedTo" -Link $administrators | ConvertFrom-SSOLinkPath | ConvertTo-SSOObjectPath
$ubilogin | Join-SSOAttributePath "metadata" | ConvertFrom-SSOAttributePath | ConvertTo-SSOObjectPath

ConvertTo-SSOObjectPath "/site"
ConvertTo-SSOObjectPath "/group/Ubilogin/Authenticated%20Users"
ConvertTo-SSOObjectPath "/site/Ubilogin/`$link/managedBy/Authenticated%20Users"
