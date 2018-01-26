
Function install_sublime
{
    Param (
            [Parameter(Mandatory=$true, Position=1)]
            [String] $path,
            [Parameter(Mandatory=$false, Position=2)]
            [Bool] $add2path
            )
    Push-Location
    Set-Location $path
    
	Write-Host Download sublimetext3 from "https://download.sublimetext.com/Sublime%20Text%20Build%203143%20x64.zip"
    download "https://download.sublimetext.com/Sublime%20Text%20Build%203143%20x64.zip"
    
    Write-Host unzip Sublime%20Text%20Build%203143%20x64.zip
    Expand-Archive Sublime%20Text%20Build%203143%20x64.zip -DestinationPath "$PWD/sublimetext3"
    Remove-Item Sublime%20Text%20Build%203143%20x64.zip -Force -Recurse -ErrorAction SilentlyContinue
    
    If ( $add2path )
    {
        Write-Host Add of alias sublime to powershell configuration
        Set-Alias sublime $PWD\sublimetext3\subl.exe
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        "Set-Alias sublime $PWD\sublimetext3\subl.exe" | Out-File -FilePath "$env:UserProfile\$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
        $env:PATH = $env:PATH + ";$PWD\sublimetext3\"
        -join('$env:PATH = $env:PATH', " + `";$PWD\sublimetext3\`"") | Out-File -FilePath "$env:UserProfile\$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    
    Pop-Location
}
