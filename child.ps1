
function Get-Child {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0,Mandatory=$true)] [string[]] $ChildValue,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Get -Context $Context | ConvertTo-Object
    }
}

function Set-Child {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0,Mandatory=$true)] [string[]] $ChildValue,
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

function Remove-Child {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter()] [AllowNull()] [ValidatePattern("\w+")] [string] $ChildType = $null,
        [Parameter(Position=0,Mandatory=$true)] [string[]] $ChildValue,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-ChildPath $PSBoundParameters | Invoke-Api -Method Delete -Context $Context 
    }
}

