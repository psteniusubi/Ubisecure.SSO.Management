function NewDefaultDisplayPropertySet {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,Mandatory=$true)] [string[]] $Names       
    )
    $local:ddps = [System.Management.Automation.PSPropertySet]::new("DefaultDisplayPropertySet", $Names)
    [System.Management.Automation.PSMemberInfo[]]$ddps
}

<#
.SYNOPSIS Create new Path object from type and segments
#>
function New-ObjectPath {
    [CmdletBinding()]
    Param(
        [Parameter()] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(Position=0,ValueFromPipeline=$true)] [AllowNull()] [string[]] $Value
    )
    Begin {
        $local:v = @()
    }
    Process {
        $Value | ? { $_ -ne "" } | % { $local:v += $_ }
    }
    End {
        $local:out = [pscustomobject]@{
            PSTypeName="SSO.ObjectPath"
            Type=$Type
            Id=[string[]]$local:v
        } 
        $local:out = $local:out | Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-ObjectPath $this } -Force -PassThru 
        $local:out = $local:out | Add-Member -MemberType ScriptProperty -Name "Value" -Value { $this.ToString() } -Force -PassThru 
        $local:out = $local:out | Add-Member -MemberType MemberSet -Name "PSStandardMembers" -Value (NewDefaultDisplayPropertySet "Value") -Force -PassThru 
        $local:out
    }
}

function PathEncode {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [string] $InputObject
    )
    Begin {
        Add-Type -AssemblyNam "System.Web"
    }
    Process {
        $InputObject | 
        % { [Web.HttpUtility]::UrlPathEncode($_) } |
        % { 
            if($_ -match "^\`$") {
                "`$$_"
            } else {
                $_
            }
        }
    }
}

function PathDecode {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [string] $InputObject
    )
    Begin {
        Add-Type -AssemblyNam "System.Web"
    }
    Process {
        $InputObject | 
        % { [Web.HttpUtility]::UrlDecode($_) } |
        % { 
            if($_ -match "^\`$") {
                if($_ -match "^\`$\`$") {
                    $_ -replace "^\`$", ""
                }
            } else {
                $_
            }
        }
    }
}

<#
.SYNOPSIS Convert Path to string
#>
function ConvertFrom-ObjectPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("SSO.ObjectPath")] $InputObject
    )
    Process {
        $InputObject | % {
            if($_.Id.Count -gt 0) {
                $local:id = ($_.Id | ? { $_ -ne "" } | % { "/$(PathEncode($_))" }) -join ""
                "/$($_.Type)$($local:id)"
            } else {
                "/$($_.Type)"
            }
        }
    }
}

<#
.SYNOPSIS Convert string to Path 
#>
function ConvertTo-ObjectPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [string] $InputObject
    )
    Process {
        $InputObject | ? { $_ -match "/(\w+)(/.*)?" } | % {
            $local:type = $Matches[1]
            if($Matches[2]) {
                $local:p = @()
                foreach($local:i in $Matches[2].Split("/")) {
                    $local:i = PathDecode($local:i)
                    if("" -eq $local:i) { continue }
                    if(-not $local:i) { break }
                    $local:p += $local:i
                }
                New-ObjectPath -Type $local:type -Value $local:p
            } else {
                New-ObjectPath -Type $local:type 
            }
        }
    }
}

<#
.SYNOPSIS Add child segments to Path
#>
function Join-ChildPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0)] [string[]] $ChildValue
    )
    Process {
        $InputObject | % {
            $local:t = $ChildType
            if(-not $local:t) {
                $local:t = $_.Type
            }
            New-ObjectPath -Type $local:t -Value ($_.Id + $ChildValue)
        }
    }
}

<#
.SYNOPSIS Select SSO.ObjectPath objects from input pipeline
#>
function Select-ChildPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0,ParameterSetName="Map")] [AllowNull()] [hashtable] $Map,
        [Parameter(ParameterSetName="Child")] [AllowNull()] [string] $ChildType = $null,
        [Parameter(ParameterSetName="Child")] [AllowNull()] [string[]] $ChildValue = $null
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "Map") {
            $local:parameters = Copy-Map -Map $Map -Keys "ChildType","ChildValue"
        } else {
            $local:parameters = Copy-Map -Map $PSBoundParameters -Keys "ChildType","ChildValue"
        }
        if($local:parameters.Count -gt 0) {
            $local:mapper = { $_ | Join-ChildPath @parameters }
        } else {
            $local:mapper = { $_ }
        }
    }
    Process {
        $InputObject | & $local:mapper | ? { $_.PSObject.TypeNames -contains "SSO.ObjectPath" }
    }
}

<#
.SYNOPSIS Create Link from two paths
#>
function Join-LinkPath {
    [CmdletBinding(DefaultParameterSetName="LinkType")]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $LinkName = $null,
        [Parameter(ParameterSetName="LinkType")] [ValidatePattern("\w+")] [string] $LinkType,
        [Parameter(Position=0,ParameterSetName="LinkType")] [AllowNull()] [string[]] $LinkValue = $null,
        [Parameter(Position=0,ParameterSetName="Link")] [PSTypeName("SSO.ObjectPath")] $Link = $null
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        if($PSCmdlet.ParameterSetName -eq "LinkType") {
            if($LinkType) {
                $Link = New-ObjectPath -Type $LinkType -Value $LinkValue
            } else {
                $Link = $null
            }
        }
    }
    Process {
        $InputObject | % {
            $local:n = $null
            if($LinkName) {
                if(-not $Link) {
                    $local:n = $LinkName
                } elseif($LinkName -ne $Link.Type) {
                    $local:n = $LinkName
                }
            }
            $local:out = New-ObjectPath -Type $_.Type -Value $_.Id
            $local:out.PSObject.TypeNames.Insert(0, "SSO.LinkPath")
            $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "LinkName" -Value $local:n -PassThru 
            $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "Link" -Value $Link -PassThru 
            $local:out = $local:out | Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-LinkPath $this } -Force -PassThru 
            Write-Verbose "Join-LinkPath return:$($local:out)"
            $local:out
        }
    }
}

<#
.SYNOPSIS Convert Link to string
#>
function ConvertFrom-LinkPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("SSO.LinkPath")] $InputObject
    )
    Process {
        $InputObject | % {
            $local:out = $_ | ConvertFrom-ObjectPath
            $local:out += "/`$link"
            if($_.LinkName) {
                if($_.LinkName -ne $_.Link.Type) {
                    $local:out += "/$($_.LinkName)"
                }
            }
            if($_.Link) {
                $local:out += $_.Link.ToString()
            }
            $local:out
        }
    }
}

<#
.SYNOPSIS Select SSO.LinkPath objects from input pipeline
#>
function Select-LinkPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0,ParameterSetName="Map")] [AllowNull()] [hashtable] $Map,
        [Parameter(ParameterSetName="Link")] [AllowNull()] [string] $LinkName = $null,
        [Parameter(ParameterSetName="Link")] [AllowNull()] [string] $LinkType = $null,
        [Parameter(ParameterSetName="Link")] [AllowNull()] [PSTypeName("SSO.ObjectPath")] $Link = $null,
        [Parameter(ParameterSetName="Link")] [AllowNull()] [string[]] $LinkValue = $null
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "Map") {
            $local:parameters = Copy-Map -Map $Map -Keys "LinkName","LinkType","Link","LinkValue"
        } else {
            $local:parameters = Copy-Map -Map $PSBoundParameters -Keys "LinkName","LinkType","Link","LinkValue"
        }
        if($local:parameters.Count -gt 0) {
            $local:mapper = { $_ | Join-LinkPath @parameters }
        } else {
            $local:mapper = { $_ }
        }
    }
    Process {
        $InputObject | & $local:mapper | ? { $_.PSObject.TypeNames -contains "SSO.LinkPath" }
    }
}

<#
.SYNOPSIS Create path to attribute name
#>
function Join-AttributePath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0)] [ValidatePattern("\w+")] [string] $Name
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        $InputObject | % {
            $local:out = New-ObjectPath -Type $_.Type -Value $_.Id
            $local:out.PSObject.TypeNames.Insert(0, "SSO.AttributePath")
            $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "AttributeName" -Value $Name -PassThru 
            $local:out = $local:out | Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-AttributePath $this } -Force -PassThru 
            Write-Verbose "Join-AttributePath return:$($local:out)"
            $local:out
        }
    }
}

<#
.SYNOPSIS Convert Attribute to string
#>
function ConvertFrom-AttributePath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("SSO.AttributePath")] $InputObject
    )
    Process {
        $InputObject | % {
            $local:out = $_ | ConvertFrom-ObjectPath
            $local:out += "/`$attribute"
            $local:out += "/$($_.AttributeName)"
            $local:out
        }
    }
}

<#
.SYNOPSIS Select SSO.AttributePath objects from input pipeline
#>
function Select-AttributePath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0,ParameterSetName="Map")] [AllowNull()] [hashtable] $Map,
        [Parameter(ParameterSetName="Name")] [AllowNull()] [string] $Name = $null
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "Map") {
            $local:parameters = Copy-Map -Map $Map -Keys "Name" 
        } else {
            $local:parameters = Copy-Map -Map $PSBoundParameters -Keys "Name" 
        }
        if($local:parameters.Count -gt 0) {
            $local:mapper = { $_ | Join-AttributePath @parameters }
        } else {
            $local:mapper = { $_ }
        }
    }
    Process {
        $InputObject | & $local:mapper | ? { $_.PSObject.TypeNames -contains "SSO.AttributePath" }
    }
}

