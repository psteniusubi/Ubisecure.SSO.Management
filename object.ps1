
function ConvertTo-Object {
    [CmdletBinding()]
    Param(
        [parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)] [xml] $InputObject
    )
    Process {
        $InputObject | 
        ? { $_.object -and $_.object.type -and $_.object.id } |
        % {
            # object type and id
            $local:out = $_.object.id | ConvertTo-ObjectPath
            $local:out.PSObject.TypeNames.Insert(0, "SSO.Object")
            # object attributes
            $local:a = @{}
            $_.object.attribute | ? { $_.name } | 
            % {
                $local:v = @()
                $_.value | % { $local:v += $_ }
                $local:a[$_.name] = $local:v
            }
            $local:out = $local:out | Add-Member -MemberType NoteProperty -Name "Attributes" -Value $local:a -PassThru 
            $local:out = $local:out | Add-Member -MemberType MemberSet -Name "PSStandardMembers" -Value (NewDefaultDisplayPropertySet "Value","Attributes") -Force -PassThru 
            $local:out
        }
    }
}

function Get-Object {
    [CmdletBinding(DefaultParameterSetName="InputObject")]
    Param(
        [Parameter(ParameterSetName="InputObject",Position=0,ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(ParameterSetName="TypeValue")] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(ParameterSetName="TypeValue",Position=0,ValueFromPipeline=$true)] [AllowNull()] [string[]] $Value,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "InputObject") {
            $local:x = { $InputObject }
        } else {
            $local:x = { New-ObjectPath -Type $Type -Value $Value }
        }
    }
    Process {
        & $local:x | Invoke-Api -Method Get -Context $Context | ConvertTo-Object
    }
}

function Set-Object {
    [CmdletBinding(DefaultParameterSetName="InputObject")]
    Param(
        [Parameter(ParameterSetName="InputObject",Position=0,ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(ParameterSetName="TypeValue")] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(ParameterSetName="TypeValue",Position=0,ValueFromPipeline=$true)] [AllowNull()] [string[]] $Value,
        [parameter()] [switch] $Enabled,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "InputObject") {
            $local:x = { $InputObject }
        } else {
            $local:x = { New-ObjectPath -Type $Type -Value $Value }
        }
    }
    Process {
        & $local:x | Invoke-Api -Method Put -Body (ConvertTo-Form $PSBoundParameters) -Context $Context | ConvertTo-Object 
    }
}

function Add-Object {
    [CmdletBinding(DefaultParameterSetName="InputObject")]
    Param(
        [Parameter(ParameterSetName="InputObject",Position=0,ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(ParameterSetName="TypeValue")] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(ParameterSetName="TypeValue",Position=0,ValueFromPipeline=$true)] [AllowNull()] [string[]] $Value,
        [parameter()] [switch] $Enabled,
        [parameter()] [AllowNull()] [string] $ChildType = $null,
        [parameter()] [AllowNull()] [string] $ChildName = $null,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "InputObject") {
            $local:x = { $InputObject }
        } else {
            $local:x = { New-ObjectPath -Type $Type -Value $Value }
        }
    }
    Process {
        & $local:x | Invoke-Api -Method Post -Body (ConvertTo-Form $PSBoundParameters -Child) -Context $Context | ConvertTo-Object 
    }
}

function Remove-Object {
    [CmdletBinding(DefaultParameterSetName="InputObject")]
    Param(
        [Parameter(ParameterSetName="InputObject",Position=0,ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(ParameterSetName="TypeValue")] [ValidatePattern("\w+")] [string] $Type,
        [Parameter(ParameterSetName="TypeValue",Position=0,ValueFromPipeline=$true)] [AllowNull()] [string[]] $Value,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        if($PSCmdlet.ParameterSetName -eq "InputObject") {
            $local:x = { $InputObject }
        } else {
            $local:x = { New-ObjectPath -Type $Type -Value $Value }
        }
    }
    Process {
        & $local:x | Invoke-Api -Method Delete -Context $Context 
    }
}

