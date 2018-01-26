
Function install_choco
{
	Write-Host Chocolatey will be install in C:\ProgramData\chocoportable
    # Set directory for installation - Chocolatey does not lock
    # down the directory if not the default
    $InstallDir="$env:ProgramData\chocoportable"
    $env:ChocolateyInstall="$InstallDir"
    # All install options - offline, proxy, etc at
    # https://chocolatey.org/install
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
