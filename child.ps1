
function Get-Child {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0)] [string[]] $ChildValue,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Get -Context $Context | ConvertTo-Object
    }
}

function Set-Child {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0)] [string[]] $ChildValue,
        [parameter()] [switch] $Enabled,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Put -Body (ConvertTo-Form $PSBoundParameters) -Context $Context | ConvertTo-Object 
    }
}

<#
function Add-Object {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0)] [string[]] $ChildValue,
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
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Post -Body (ConvertTo-Form $PSBoundParameters -Child) -Context $Context | ConvertTo-Object 
    }
}
#>

function Remove-Child {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0)] [string[]] $ChildValue,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Delete -Context $Context 
    }
}

