#!/usr/bin/env pwsh

#$url = "https://dl.influxdata.com/telegraf/releases/telegraf-1.5.2_windows_amd64.zip"

Function install_telegraf
{
    Param (
            [Parameter(Mandatory=$true, Position=0)]
            [String] $url,
            [Parameter(Mandatory=$true, Position=1)]
            [String] $path,
            [Parameter(Mandatory=$false, Position=2)]
            [Bool] $add2path
            )
    Push-Location
    Set-Location $path
    
    Write-Host "Download telegraf from "$url
    $out_dir = $url.split('/')[-1]
    $out = $out_dir.Substring(0, $out_dir.Length - 4) # remove extension (.zip)
    $Job = Start-BitsTransfer -Source $url -Asynchronous
    while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) `
    { sleep 5;} # Poll for status, sleep for 5 seconds, or perform an action.

    Switch($Job.JobState)
    {
        "Transferred" {Complete-BitsTransfer -BitsJob $Job}
        "Error" {$Job | Format-List } # List the errors.
        default {"Other action"} #  Perform corrective action.
    }

    Write-Host unzip $out_dir
    Expand-Archive $out_dir -DestinationPath $path/telegraf
    If ( $add2path )
    {
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        -join('$env:PATH = $env:PATH', " + `";$PWD\telegraf\telegraf\`"") | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    $env:PATH = $env:PATH + ";$PWD\telegraf\telegraf\"
    Remove-Item $out_dir -Force -Recurse -ErrorAction SilentlyContinue

    Pop-Location
}