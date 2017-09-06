Import-Module -Name "querystring" -Scope Local
Import-Module -Name "oauth2" -Scope Local

function ConvertTo-Form {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [hashtable] $Map,
        [Parameter()] [switch] $Child
    )
    # Enabled, Type, Name, Attributes
    Process {
        $local:form = New-QueryString
        [bool]$Map["Enabled"] | ? { $_ } | % { $local:form = $local:form | Add-QueryString "enabled" "true" }
        if($Child) {
            [string]$Map["ChildType"] | ? { $_ } | % { $local:form = $local:form | Add-QueryString "type" $_ }
            [string]$Map["ChildName"] | ? { $_ } | % { $local:form = $local:form | Add-QueryString "name" $_ }
        }
        [collections.idictionary]$Map["Attributes"] | ? { $_ } | % { $local:form = $local:form | Add-QueryString -Values $_ }
        $local:out = $local:form | ConvertTo-QueryString
        Write-Verbose "ConvertTo-Form return:$($local:out)"
        $local:out
    }
}

function ConvertFrom-Map {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [hashtable] $InputObject
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        $InputObject | % {
            $local:out = "@{"
            $local:out += $(foreach($local:key in $_.Keys) {
                "$($local:key)=$($_[$local:key])"
            }) -join ";" 
            $local:out += "}"
            $local:out
        }
    }
}

function Copy-Map {
    [CmdletBinding()]
    Param(
        [Parameter()] [hashtable] $Map,
        [Parameter()] [string[]] $Keys
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        $local:copy = [hashtable]::new()
        $Keys | ? { $_ -and $Map.ContainsKey($_) } | % { $local:copy[$_] = $Map[$_] }
        Write-Verbose "Copy-Map return:$($local:copy | ConvertFrom-Map)"
        $local:copy
    }
}

function Invoke-Api {
    [CmdletBinding()]
    Param(
        [Parameter()] [Microsoft.PowerShell.Commands.WebRequestMethod] $Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,
        [Parameter(Position=0,ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [hashtable] $Headers = $null,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $local:h = $Context.Bearer | ConvertTo-OAuthHttpBearer | ConvertTo-OAuthHttpAuthorization
        if($Accept) {
            $local:h += @{"Accept"=$Accept}
        }
        if($Headers) {
            $local:h += $Headers
        }
    }
    Process {
        $InputObject | % { "$($Context.BaseUri)$($_.ToString())" } | % {
            Write-Verbose "$Method $_ Content-Type:$ContentType Body:$Body" 
            Invoke-RestMethod -Method $Method -Uri $_ -ContentType $ContentType -Headers $local:h -Body $Body
        }
    }
}

