Import-Module -Name "querystring" -Scope Local

function ConvertTo-Link {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true)] [xml] $InputObject
    )
    Begin {
    }
    Process {
        $InputObject | 
        ? { $_.object -and $_.object.type -and $_.object.id } |
        % {
            $local:o = $_.object.id | ConvertTo-ObjectPath
            if($local:o) {
                $_.object.object | 
                ? { $_.type -and $_.id -and $_.link } |
                % {
                    $local:out = [PSCustomObject]@{
                        PSTypeName = "SSO.Link"
                        Reference = (Join-SSOLinkPath -Path $local:o -LinkName $_.link -Link (ConvertTo-ObjectPath $_.id))
                    }
                    if($_.enabled) { 
                        $local:out | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $_.enabled 
                    }
                    if($_.index) { 
                        $local:out | Add-Member -MemberType NoteProperty -Name "Index" -Value ($_.index | ConvertTo-ObjectPath)
                    }
                    $local:out
                }
            }
        }
    }
}

function Get-Link {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Reference | Invoke-Api -Method Get -Context $Context | ConvertTo-Link
    }
}

function Set-Link {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
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
        $Reference | Invoke-Api -Method Put -Body $local:form -Context $Context | ConvertTo-Link
    }
}

function Add-Link {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
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
        $Reference | Invoke-Api -Method Post -Body $local:form -Context $Context | ConvertTo-Link
    }
}

function Remove-Link {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [PSTypeName("Link.Path")] $Reference,
        [Parameter()] [PSTypeName("Context")] $Context = (GetContext)
    )
    Process {
        $Reference | Invoke-Api -Method Delete -Context $Context 
    }
}

