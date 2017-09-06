
function Get-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0)] [AllowNull()] [string] $Name = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
    }
    Process {
        $InputObject | Select-AttributePath $PSBoundParameters | Invoke-Api -Method Get -Context $Context 
    }
}

function Set-Attribute {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0)] [AllowNull()] [string] $Name = $null,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $InputObject | Select-AttributePath $PSBoundParameters | Invoke-Api -Method Put -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Add-Attribute {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0)] [AllowNull()] [string] $Name = $null,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $InputObject | Select-AttributePath $PSBoundParameters | Invoke-Api -Method Post -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Remove-Attribute {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(ValueFromPipeline=$true)] [PSTypeName("SSO.ObjectPath")] $InputObject,
        [Parameter(Position=0)] [AllowNull()] [string] $Name = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $InputObject | Select-AttributePath $PSBoundParameters | Invoke-Api -Method Delete -Context $Context 
    }
}

