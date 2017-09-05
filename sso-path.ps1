<#
.SYNOPSIS Create new Path object from type and segments
#>
function New-ObjectPath {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(ValueFromPipeline=$true,Position=0)] [AllowNull()] [string[]] $Value
    )
    Begin {
        $local:ddps = [System.Management.Automation.PSPropertySet]::new("DefaultDisplayPropertySet", [string[]]@("Type","Value"))
        $local:v = @()
    }
    Process {
        $Value | ? { $_ -ne "" } | % { $local:v += $_ }
    }
    End {
        [pscustomobject]@{
            PSTypeName="Object.Path"
            Type=$Type
            Id=[string[]]$local:v
        } |
        Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-ObjectPath $this } -Force -PassThru |
        Add-Member -MemberType ScriptProperty -Name "Value" -Value { $this.ToString() } -Force -PassThru |
        Add-Member -MemberType MemberSet -Name "PSStandardMembers" -Value ([System.Management.Automation.PSMemberInfo[]]$ddps) -Force -PassThru 
    }
}

function PathEncode {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0)] [string] $InputObject
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
        [Parameter(Position=0)] [string] $InputObject
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
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("Object.Path")] $InputObject
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
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $Type = $null,
        [Parameter(Position=0)] [string[]] $Value
    )
    Process {
        $Id | % {
            $local:t = $Type
            if(-not $local:t) {
                $local:t = $_.Type
            }
            New-ObjectPath -Type $local:t -Value ($_.Id + $Value)
        }
    }
}

<#
.SYNOPSIS Create Link from two paths
#>
function Join-LinkPath {
    [CmdletBinding(DefaultParameterSetName="LinkType")]
    Param(
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $LinkName = $null,
        [Parameter(ParameterSetName="LinkType")] [AllowNull()] [ValidatePattern("\w+")] [string] $LinkType = $null,
        [Parameter(Position=0,ParameterSetName="Link")] [PSTypeName("Object.Path")] $Link
    )
    Begin {
        #
    }
    Process {
        $Id | % {
            if((-not $Link) -and $LinkType) {
                $Link = New-ObjectPath -Type $LinkType
            }
            $local:n = $null
            if($LinkName) {
                if(-not $Link) {
                    $local:n = $LinkName
                } elseif($LinkName -ne $Link.Type) {
                    $local:n = $LinkName
                }
            }
            [pscustomobject]@{
                PSTypeName="Link.Path"
                Id=$_
                LinkName=$local:n
                Link=$Link
            } |
            Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-LinkPath $this } -Force -PassThru 
        }
    }
}

<#
.SYNOPSIS Convert Link to string
#>
function ConvertFrom-LinkPath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("Link.Path")] $InputObject
    )
    Process {
        $InputObject | % {
            $local:out = $_.Id.ToString()
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
.SYNOPSIS Create path to attribute name
#>
function Join-AttributePath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(Position=0)] [ValidatePattern("\w+")] [string] $Name
    )
    Begin {
        #
    }
    Process {
        $Id | % {
            [pscustomobject]@{
                PSTypeName="Attribute.Path"
                Id=$_
                Name=$Name
            } |
            Add-Member -MemberType ScriptMethod -Name "ToString" -Value { ConvertFrom-AttributePath $this } -Force -PassThru 
        }
    }
}

<#
.SYNOPSIS Convert Attribute to string
#>
function ConvertFrom-AttributePath {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Position=0)] [PSTypeName("Attribute.Path")] $InputObject
    )
    Process {
        $InputObject | % {
            $local:out = $_.Id.ToString()
            $local:out += "/`$attribute"
            $local:out += "/$($_.Name)"
            $local:out
        }
    }
}

