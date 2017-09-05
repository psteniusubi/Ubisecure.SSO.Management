Import-Module -Name ($PSCommandPath | Split-Path -Parent | Join-Path -ChildPath "sso-api.psm1") 

function Get-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Attribute | Invoke-Api -Method Get -Context $Context 
    }
}

function Set-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Attribute | Invoke-Api -Method Put -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Add-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Attribute | Invoke-Api -Method Post -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Remove-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Attribute | Invoke-Api -Method Delete -Context $Context 
    }
}

