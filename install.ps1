#!/usr/bin/env pwsh

# $args[0] = -y
# $args[1] = installation path from root
# $args[2] = silent mode (true/false)

$confirm = $args[0]
If( $args[1] -eq $null )
{
  $path2out = "toolchain"
} # specify path to install programs
Else
{
  $path2out = $args[1]
}
$silent = $args[2]

$PROFILE

$project = "shut"
$log = "install_$project.log"

# For the right Permission
# Set-ExecutionPolicy Bypass -Scope CurrentUser

$Documents = [Environment]::GetFolderPath('MyDocuments')

Write-Host "Installing $project dependecies:" -ForegroundColor Yellow
Write-Host "  - cmake"
. ".\pwsh\install_cmake.ps1"
Write-Host "  - (Conda) Python3"
. ".\pwsh\install_python.ps1"
Write-Host "  - g++"
Write-Host "  - make"
. ".\pwsh\install_g++.ps1"
Write-Host "  - Chocolatey (recommended)"
. ".\pwsh\install_choco.ps1"
Write-Host "  - SublimeText3 (recommended)"
. ".\pwsh\install_sublimetext3.ps1"
Write-Host "  - Ninja"
. ".\pwsh\install_ninja.ps1"


Write-Host "Installation path : $env:HOMEDRIVE$env:HOMEPATH\$path2out" -ForegroundColor Green

Push-Location
Set-Location $env:HOMEDRIVE$env:HOMEPATH > $null
New-Item -Path $path2out -ItemType directory -Force > $null
New-Item -Path $Documents\WindowsPowerShell -ItemType directory -Force > $null
Set-Location $path2out

Write-Host "Looking for packages..."
Remove-Item $log -Force -Recurse -ErrorAction SilentlyContinue

# CMAKE Installer
Write-Host "Installation CMake"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_cmake -add2path $true -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

# Miniconda3 Installer
Write-Host "Installation Python3"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_python -add2path $true -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

# g++ Installer
Write-Host "Installation g++"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_g++ -add2path $true -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

# Chocolatey Installer
Write-Host "Installation Chocolatey"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_choco -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

# Sublime Installer
Write-Host "Installation SublimeText3"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_sublimetext3 -add2path $true -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

# Ninja-build Installer
Write-Host "Installation Ninja-build"
if ( $silent )
{
  Start-Transcript -Append -Path $log
}
install_ninja -add2path $true -confirm $confirm
if ( $silent )
{
  Stop-Transcript
}

Pop-Location > $null

# Build project
#Write-Host "Build $project" -ForegroundColor Yellow
#if ( $silent )
#{
#  & .\build.ps1
#}

