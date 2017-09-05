Import-Module -Name ($PSCommandPath | Split-Path -Parent | Join-Path -ChildPath "Get-CallerPreference.psm1") 

function New-Context {
    [CmdletBinding()]
    param(
    [parameter(Mandatory=$true,Position=0)] [string] $BaseUri, 
    [parameter(Mandatory=$true,Position=1)] [System.Net.NetworkCredential] $Bearer
    )
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        Remove-Context
        [psvariable] $private:c = New-Variable -Name "Context" -Option Private -Scope script -Visibility Private -PassThru
        $private:c.Value = [PSCustomObject]@{
            PSTypeName = "Context"
            BaseUri = $BaseUri
            Bearer = $Bearer
        }
    }
}

function GetContext {
    [CmdletBinding()]
    param()
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        [psvariable] $private:c = Get-Variable -Name "Context" -Scope script -ErrorAction SilentlyContinue
        if(-not $private:c) {
            throw "Context is not defined"
        }
        return $private:c.Value
    }
}

function Remove-Context {
    [CmdletBinding()]
    param()
    Begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    Process {
        Remove-Variable -Force -Name "Context" -Scope script -ErrorAction SilentlyContinue 
    }
}
