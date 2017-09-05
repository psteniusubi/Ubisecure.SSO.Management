$env:HOME | Join-Path -ChildPath "Documents\WindowsPowerShell\sso-api-v2\sso-api-v2.psd1" | Import-Module -Force 

New-ObjectPath -Type "site" 
New-ObjectPath -Type "site" -Value "System" 
New-ObjectPath -Type "site" -Value "System" | Join-ChildPath -Value "Password"
New-ObjectPath -Type "site" "System" | Join-ChildPath "Password"
New-ObjectPath -Type "site" "System","Password"
New-ObjectPath -Type "site" -Value "System" | Join-ChildPath -Type "application" "Ubilogin"

New-ObjectPath -Type "site" -Value "System" | Get-Member


$ubilogin = New-ObjectPath -Type "application" -Value "System","Ubilogin"
$administrators = New-ObjectPath -Type "group" -Value "System","Administrators"

$ubilogin | Join-LinkPath -LinkName "allowedTo"
$ubilogin | Join-LinkPath -LinkName "allowedTo" -LinkType "group"
$ubilogin | Join-LinkPath -LinkType "group"
$ubilogin | Join-LinkPath -LinkName "allowedTo" $administrators

($ubilogin | Join-LinkPath -LinkName "allowedTo" $administrators).ToString()
$ubilogin | Join-LinkPath -LinkName "allowedTo" $administrators | Get-Member

New-ObjectPath -Type "site" "System" | Join-ChildPath -Type "application" "Ubilogin"
New-ObjectPath -Type "site" "System" | Join-ChildPath -Type "group" "Authenticated Users"
New-ObjectPath -Type "site" "System" | Join-ChildPath "SSO API" | Join-ChildPath -Type "application" "SSO API"
New-ObjectPath -Type "application" "System","SSO API","SSO API"

$ubilogin | Join-AttributePath "metadata"

($ubilogin | Join-AttributePath "metadata").ToString()
$ubilogin | Join-AttributePath "metadata" | Get-Member

$ubilogin | ConvertFrom-ObjectPath
$ubilogin | Join-LinkPath -LinkName "allowedTo" -Link $administrators | ConvertFrom-LinkPath
$ubilogin | Join-AttributePath "metadata" | ConvertFrom-AttributePath

$ubilogin | ConvertFrom-ObjectPath | ConvertTo-ObjectPath
$ubilogin | Join-LinkPath -LinkName "allowedTo" -Link $administrators | ConvertFrom-LinkPath | ConvertTo-ObjectPath
$ubilogin | Join-AttributePath "metadata" | ConvertFrom-AttributePath | ConvertTo-ObjectPath

ConvertTo-ObjectPath "/site"
ConvertTo-ObjectPath "/group/Ubilogin/Authenticated%20Users"
ConvertTo-ObjectPath "/site/Ubilogin/`$link/managedBy/Authenticated%20Users"
