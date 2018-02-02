#!/usr/bin/env pwsh

Function install_ninja
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
    
    Write-Host Download ninja from $url
    $out_dir = $url.split('/')[-1]
    
    if (Test-Path $out_dir)
    {
        return
    }
    $downloadPartPath = "$out_dir.part"
    Invoke-WebRequest $url -OutFile $downloadPartPath
    #$wc = New-Object System.Net.WebClient
    #$wc.DownloadFile($url, $downloadPartPath)
    Move-Item -Path $downloadPartPath -Destination $out_dir
    Remove-Item $downloadPartPath -Force -ErrorAction SilentlyContinue

    Write-Host unzip $out_dir
    Expand-Archive $out_dir -DestinationPath ninja
    If ( $add2path )
    {
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        $env:PATH = $env:PATH + ";$PWD\ninja\"
        -join('$env:PATH = $env:PATH', " + `";$PWD\ninja\`"") | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    Remove-Item $out_dir -Force -Recurse -ErrorAction SilentlyContinue

    Pop-Location
}
