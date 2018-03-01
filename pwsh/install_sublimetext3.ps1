#!/usr/bin/env pwsh

Function get_sublime
{
    Param(
            [Bool] $add2path
        )
    
    $url_sublime = "https://download.sublimetext.com/Sublime%20Text%20Build%203143%20x64.zip"

    Write-Host Download sublimetext3 from $url_sublime
    $Job = Start-BitsTransfer -Source $url_sublime -Asynchronous
    while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) `
    { sleep 5;} # Poll for status, sleep for 5 seconds, or perform an action.

    Switch($Job.JobState) {
        "Transferred" {Complete-BitsTransfer -BitsJob $Job}
        "Error" {$Job | Format-List } # List the errors.
        default {"Other action"} #  Perform corrective action.
    }
    
    Write-Host unzip Sublime%20Text%20Build%203143%20x64.zip
    Expand-Archive Sublime%20Text%20Build%203143%20x64.zip -DestinationPath "$PWD/sublimetext3"
    Remove-Item Sublime%20Text%20Build%203143%20x64.zip -Force -Recurse -ErrorAction SilentlyContinue
    
    If ( $add2path ) {
        Write-Host Add of alias sublime to powershell configuration
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        "Set-Alias sublime $PWD\sublimetext3\subl.exe" | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
        -join('$env:PATH = $env:PATH', " + `";$PWD\sublimetext3\`"") | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    Set-Alias sublime $PWD\sublimetext3\subl.exe
    $env:PATH = $env:PATH + ";$PWD\sublimetext3\"
}

Function install_sublimetext3
{
    Param(
            [Bool] $add2path,
            [Parameter(Mandatory=$false)] [String] $confirm = ""
        )
    Write-Host "SublimeText3 identification: " -NoNewLine
    $sub = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue( "DisplayName" ) -like "*sublime*"} | Select Name) -Or (Get-Command subl*)
    If( $sub -eq $false){ # not installed
        Write-Host "NOT FOUND"
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ){ get_sublime -add2path $add2path }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red}
            Else{ get_sublime -add2path $add2path }
        }
    }
    Else{ Write-Host "FOUND" -ForegroundColor Green}
	
    
}
