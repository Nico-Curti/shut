#!/usr/bin/env pwsh

Function get_choco
{
    $url_choco = "https://chocolatey.org/install.ps1"
	Write-Host Chocolatey will be install in C:\ProgramData\chocoportable
    # Set directory for installation - Chocolatey does not lock
    # down the directory if not the default
    $InstallDir="$env:ProgramData\chocoportable"
    $env:ChocolateyInstall="$InstallDir"
    # All install options - offline, proxy, etc at
    # https://chocolatey.org/install
    iex ((New-Object System.Net.WebClient).DownloadString($url_choco))
}

Function install_choco
{
    Param (
            [Parameter(Mandatory=$false)] [String] $confirm = ""
            )
    Write-Host "Chocolatey identification: " -NoNewLine
    $choco = Get-Command choco -ErrorAction SilentlyContinue
    If( $choco -eq $null ){
        Write-Host "NOT FOUND" -ForegroundColor Red
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ) { get_choco }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red}
            Else{ get_choco }
        }
    }
    Else { Write-Host "FOUND" -ForegroundColor Green}
}
