
function Get-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Attribute",Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter(ParameterSetName="Id",ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Id",Position=0)] [ValidatePattern("\w+")] [string] $Name,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        $local:expr = {}
        switch($PSCmdlet.ParameterSetName) {
            "Attribute" { $local:expr = { $Attribute } }
            "Id" { $local:expr = { $Id | Join-AttributePath -Name $Name } }
        }
        $local:expr.Invoke() | Invoke-Api -Method Get -Context $Context 
    }
}

function Set-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Attribute",Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter(ParameterSetName="Id",ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Id",Position=0)] [ValidatePattern("\w+")] [string] $Name,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $local:expr = {}
        switch($PSCmdlet.ParameterSetName) {
            "Attribute" { $local:expr = { $Attribute } }
            "Id" { $local:expr = { $Id | Join-AttributePath -Name $Name } }
        }
        $local:expr.Invoke() | Invoke-Api -Method Put -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Add-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Attribute",Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter(ParameterSetName="Id",ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Id",Position=0)] [ValidatePattern("\w+")] [string] $Name,
        [Parameter()] [AllowNull()] [string] $ContentType = "application/x-www-form-urlencoded",
        [Parameter()] [AllowNull()] [string] $Accept = $null,
        [Parameter()] [AllowNull()] [object] $Body = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $local:expr = {}
        switch($PSCmdlet.ParameterSetName) {
            "Attribute" { $local:expr = { $Attribute } }
            "Id" { $local:expr = { $Id | Join-AttributePath -Name $Name } }
        }
        $local:expr.Invoke() | Invoke-Api -Method Post -ContentType $ContentType -Accept $Accept -Body $Body -Context $Context 
    }
}

function Remove-Attribute {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Attribute",Position=0,ValueFromPipeline=$true)] [PSTypeName("Attribute.Path")] $Attribute,
        [Parameter(ParameterSetName="Id",ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Id",Position=0)] [ValidatePattern("\w+")] [string] $Name,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $local:expr = {}
        switch($PSCmdlet.ParameterSetName) {
            "Attribute" { $local:expr = { $Attribute } }
            "Id" { $local:expr = { $Id | Join-AttributePath -Name $Name } }
        }
        $local:expr.Invoke() | Invoke-Api -Method Delete -Context $Context 
    }
}

