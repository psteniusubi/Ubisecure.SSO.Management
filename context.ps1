
$script:Context = @{}

function New-Context {
    [CmdletBinding()]
    param(
    [parameter(Mandatory=$false)] [string] $Name = "default", 
    [parameter(Mandatory=$true,Position=0)] [string] $BaseUri, 
    [parameter(Mandatory=$true,Position=1)] [System.Net.NetworkCredential] $Bearer
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        Remove-Context -Name $Name
        $script:Context[$Name] = [PSCustomObject]@{
            PSTypeName = "Context"
            BaseUri = $BaseUri
            Bearer = $Bearer
        }
    }
}

function GetContext {
    [CmdletBinding()]
    param(
    [parameter(Mandatory=$false)] [string] $Name = "default"
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        if(-not $script:Context.ContainsKey($Name)) {
            throw [System.ApplicationException]::new("SSO API Logon Context is not defined")
        }
        $script:Context[$Name]
    }
}

function Remove-Context {
    [CmdletBinding()]
    param(
    [parameter(Mandatory=$false)] [string] $Name = "default"
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        $script:Context.Remove($Name) | Out-Null
    }
}
