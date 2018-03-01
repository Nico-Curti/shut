#!/usr/bin/env pwsh

Function get_telegraf
{
    Param (
            [Bool] $add2path
            )

    $url_telegraf = "https://dl.influxdata.com/telegraf/releases/telegraf-1.5.2_windows_amd64.zip"

    Write-Host "Download telegraf from "$url_telegraf
    $out_dir = $url_telegraf.split('/')[-1]
    $out = $out_dir.Substring(0, $out_dir.Length - 4) # remove extension (.zip)
    $Job = Start-BitsTransfer -Source $url_telegraf -Asynchronous
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
}

Function install_telegraf
{
    Param(
            [Bool] $add2path,
            [Parameter(Mandatory=$false)] [String] $confirm = ""
        )

    If( -Not (Get-Command telegraf -ErrorAction SilentlyContinue) ){ # ninja not installed
        Write-Host "NOT FOUND" -ForegroundColor Red
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ){ get_telegraf -add2path $add2path }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red}
            Else{ get_telegraf -add2path $add2path }
        }
    }
    Else{ Write-Host "FOUND" -ForegroundColor Green}
}