#!/usr/bin/env pwsh

Function get_ninja
{
    Param(
            [Bool] $add2path
        )

    $ninja_version = "1.8.2"
    $url_ninja = "https://github.com/ninja-build/ninja/releases/download/v$ninja_version/ninja-win.zip"

    Write-Host Download ninja from $url
    $out_dir = $url_ninja.split('/')[-1]
    
    if (Test-Path $out_dir) { return }
    $downloadPartPath = "$out_dir.part"
    Invoke-WebRequest $url_ninja -OutFile $downloadPartPath
    #$wc = New-Object System.Net.WebClient
    #$wc.DownloadFile($url, $downloadPartPath)
    Move-Item -Path $downloadPartPath -Destination $out_dir
    Remove-Item $downloadPartPath -Force -ErrorAction SilentlyContinue

    Write-Host unzip $out_dir
    Expand-Archive $out_dir -DestinationPath ninja
    If ( $add2path ) {
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        -join('$env:PATH = $env:PATH', " + `";$PWD\ninja\`"") | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    $env:PATH = $env:PATH + ";$PWD\ninja\"
    Remove-Item $out_dir -Force -Recurse -ErrorAction SilentlyContinue

}

Function install_ninja
{
    Param(
            [Bool] $add2path,
            [Parameter(Mandatory=$false)] [String] $confirm = ""
        )

    Write-Host "ninja-build identification: " -NoNewLine
    If( -Not (Get-Command ninja -ErrorAction SilentlyContinue) ){ # ninja not installed
        Write-Host "NOT FOUND" -ForegroundColor Red
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ){ get_ninja -add2path $add2path }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red}
            Else{ get_ninja -add2path $add2path }
        }
    }
    Else{ Write-Host "FOUND" -ForegroundColor Green}
    
}
