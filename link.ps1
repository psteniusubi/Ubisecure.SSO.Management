
function ConvertTo-Link {
    [CmdletBinding()]
    Param(
        [parameter(Position=0,ValueFromPipeline=$true)] [xml] $InputObject
    )
    Begin {
    }
    Process {
        $InputObject | 
        ? { $_.object -and $_.object.type -and $_.object.id } |
        % {
            # object id
            $local:id = $_.object.id | ConvertTo-ObjectPath
            # child objects
            $_.object.object | 
            ? { $_.type -and $_.id -and $_.link } |
            % {
                $local:out = $local:id | Join-LinkPath -LinkName $_.link -Link ($_.id | ConvertTo-ObjectPath)
                $local:out.PSObject.TypeNames.Insert(0, "SSO.Link")
                if($_.enabled) { 
                    $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $_.enabled -PassThru
                }
                if($_.index) { 
                    $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "Index" -Value ($_.index | ConvertTo-ObjectPath) -PassThru
                }
                $local:out = $local:out | Add-Member -MemberType MemberSet -Name "PSStandardMembers" -Value (NewDefaultDisplayPropertySet "Value","Enabled","Index") -Force -PassThru 
                $local:out
            }
        }
    }
}

function Get-Link {
    [CmdletBinding(DefaultParameterSetName="Link")]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [string] $LinkName = $null,
        [Parameter(ParameterSetName="Link",Position=0)] [AllowNull()] [PSTypeName("SSO.ObjectPath")] $Link = $null,
        [Parameter(ParameterSetName="LinkValue",Mandatory=$true)] [string] $LinkType,
        [Parameter(ParameterSetName="LinkValue",Position=0)] [AllowNull()] [string[]] $LinkValue = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-LinkPath $PSBoundParameters | Invoke-Api -Method Get -Context $Context | ConvertTo-Link
    }
}

<#
.SYNOPSIS Select Link property from input pipeline
#>
function Select-Link {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.LinkPath")] $InputObject,
        [Parameter(ParameterSetName="Id")] [switch] $Id,
        [Parameter(ParameterSetName="Link")] [switch] $Link,
        [Parameter(ParameterSetName="Index")] [switch] $Index
    )
    Process {
        $InputObject | % {
            if($Id) { New-ObjectPath -Type $_.Type -Value $_.Id }
            elseif($Link) { $_.Link }
            elseif($Index) { $_.Index }
        }
    }
}

function Set-Link {
    [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName="Link")]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [string] $LinkName = $null,
        [Parameter(ParameterSetName="Link",Position=0)] [AllowNull()] [PSTypeName("SSO.ObjectPath")] $Link = $null,
        [Parameter(ParameterSetName="LinkValue",Mandatory=$true)] [string] $LinkType,
        [Parameter(ParameterSetName="LinkValue",Position=0)] [AllowNull()] [string[]] $LinkValue = $null,
        [parameter()] [switch] $Enabled,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-LinkPath $PSBoundParameters | Invoke-Api -Method Put -Body (ConvertTo-Form $PSBoundParameters) -Context $Context | ConvertTo-Link
    }
}

function Add-Link {
    [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName="Link")]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [string] $LinkName = $null,
        [Parameter(ParameterSetName="Link",Position=0)] [AllowNull()] [PSTypeName("SSO.ObjectPath")] $Link = $null,
        [Parameter(ParameterSetName="LinkValue",Mandatory=$true)] [string] $LinkType,
        [Parameter(ParameterSetName="LinkValue",Position=0)] [AllowNull()] [string[]] $LinkValue = $null,
        [parameter()] [switch] $Enabled,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-LinkPath $PSBoundParameters | Invoke-Api -Method Post -Body (ConvertTo-Form $PSBoundParameters) -Context $Context | ConvertTo-Link
    }
}

function Remove-Link {
    [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName="Link")]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [string] $LinkName = $null,
        [Parameter(ParameterSetName="Link",Position=0)] [AllowNull()] [PSTypeName("SSO.ObjectPath")] $Link = $null,
        [Parameter(ParameterSetName="LinkValue",Mandatory=$true)] [string] $LinkType,
        [Parameter(ParameterSetName="LinkValue",Position=0)] [AllowNull()] [string[]] $LinkValue = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $InputObject | Select-LinkPath $PSBoundParameters | Invoke-Api -Method Delete -Context $Context 
    }
}

