Import-Module -Name Microsoft.WSMan.Management

function Remove-OldTempFiles {
    $tempFolder = "$env:TEMP\*"
    $cutoffDate = (Get-Date).AddMonths(-1)

    Get-ChildItem -Path $tempFolder -Recurse | 
    Where-Object { $_.LastWriteTime -lt $cutoffDate } |
    Remove-Item -Recurse -Force
}

function Connection {
    param (
        [Parameter(Mandatory=$true)]
        [string]$computerName,
        [Parameter(Mandatory=$true)]
        [string]$cred
    )
    Invoke-Command -ComputerName $computerName -Credential $cred -ScriptBlock ${function:Remove-OldTempFiles}
}