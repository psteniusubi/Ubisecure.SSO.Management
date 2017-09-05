Import-Module -Name "querystring" -Scope Local

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
            $local:out = [PSCustomObject]@{
                PSTypeName = "SSO.Object"
                Id = ($_.object.id | ConvertTo-ObjectPath)
                Attributes = [PSCustomObject]@{}
            }
            # object attributes
            $_.object.attribute | ? { $_.name } | 
            % {
                $local:out.Attributes | Add-Member -MemberType NoteProperty -Name $_.name -Value $_.value
            }
            $local:out
        }
    }
}

function Get-Object {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Id",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Reference",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        switch($PSCmdlet.ParameterSetName) {
            "Id" { $Id | Invoke-Api -Method Get -Context $Context | ConvertTo-Object }
            "Reference" { $Reference | % { $_.Link } | Invoke-Api -Method Get -Context $Context | ConvertTo-Object }
        }
    }
}

function Set-Object {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Id",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Reference",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [parameter()] [switch] $Enabled,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        $local:form = New-QueryString
        if($Enabled) {
            $local:form = $local:form | Add-QueryString "enabled" "true"
        }
        if($Attributes) {
            $local:form = $local:form | Add-QueryString -Values $Attributes
        }
        $local:form = $local:form | ConvertTo-QueryString
    }
    Process {
        switch($PSCmdlet.ParameterSetName) {
            "Id" { $Id | Invoke-Api -Method Put -Body $local:form -Context $Context | ConvertTo-Object }
            "Reference" { $Reference | % { $_.Link } | Invoke-Api -Method Put -Body $local:form -Context $Context | ConvertTo-Object }
        }
    }
}

function Add-Object {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Id",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Reference",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [parameter()] [switch] $Enabled,
        [parameter()] [AllowNull()] [string] $Type = $null,
        [parameter()] [AllowNull()] [string] $Name = $null,
        [parameter()] [hashtable] $Attributes = $null,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Begin {
        $local:form = New-QueryString
        if($Enabled) {
            $local:form = $local:form | Add-QueryString "enabled" "true"
        }
        if($Type) {
            $local:form = $local:form | Add-QueryString "type" $Type
        }
        if($Name) {
            $local:form = $local:form | Add-QueryString "name" $Name
        }
        if($Attributes) {
            $local:form = $local:form | Add-QueryString -Values $Attributes
        }
        $local:form = $local:form | ConvertTo-QueryString
    }
    Process {
        switch($PSCmdlet.ParameterSetName) {
            "Id" { $Id | Invoke-Api -Method Post -Body $local:form -Context $Context | ConvertTo-Object }
            "Reference" { $Reference | % { $_.Link } | Invoke-Api -Method Post -Body $local:form -Context $Context | ConvertTo-Object }
        }
    }
}

function Remove-Object {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="Id",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Object.Path")] $Id,
        [Parameter(ParameterSetName="Reference",Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        switch($PSCmdlet.ParameterSetName) {
            "Id" { $Id | Invoke-Api -Method Delete -Context $Context }
            "Reference" { $Reference | % { $_.Link } | Invoke-Api -Method Delete -Context $Context }
        }
    }
}

