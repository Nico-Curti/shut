#!/usr/bin/env pwsh

Function get_python
{
    Param (
            [Bool] $add2path,
            [Parameter(Mandatory=$false, ValueFromRemainingArguments=$false)]
            [String[]] $modules
            )
    
    $url_python = "https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe"

    Write-Host "Download Python from "$url_python
    $exec = $url_python.split('/')[-1]
    $conda = $exec.split('-')[0] # miniconda/anaconda

    $Job = Start-BitsTransfer -Source $url_python -Asynchronous
    while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) `
    { sleep 5;} # Poll for status, sleep for 5 seconds, or perform an action.

    Switch($Job.JobState)
    {
        "Transferred" {Complete-BitsTransfer -BitsJob $Job}
        "Error" {$Job | Format-List } # List the errors.
        default {"Other action"} #  Perform corrective action.
    }

    Write-Host $conda will be install and it will set as default python
    cmd.exe /c "start /wait `"`" $exec /InstallationType=JustMe /RegisterPython=0 /S /D=%UserProfile%\$conda"
    Remove-Item $conda -Force -ErrorAction SilentlyContinue
    $conda = $conda.ToLower()
    If ( $add2path )
    {
        $Documents = [Environment]::GetFolderPath('MyDocuments')
        -join('$env:PATH = $env:PATH', " + `";$env:UserProfile\$conda;$env:UserProfile\$conda\Scripts;$env:UserProfile\$conda\Library\bin;$env:UserProfile\$conda\Library\usr\bin;$env:UserProfile\$conda\Library\mingw-w64\bin;`"") | Out-File -FilePath "$env:UserProfile\$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    $env:PATH = $env:PATH + ";$env:UserProfile\$conda;$env:UserProfile\$conda\Scripts;$env:UserProfile\$conda\Library\bin;$env:UserProfile\$conda\Library\usr\bin;$env:UserProfile\$conda\Library\mingw-w64\bin;"
    conda update conda -y
    conda config --add channels bioconda
    Foreach ($i in $modules)
    {
        pip install $i
    }
}


Function install_python
{
    Param(
            [Bool] $add2path,
            [Parameter(Mandatory=$false)] [String] $confirm = "",
            [Parameter(Mandatory=$false, ValueFromRemainingArguments=$false)] [String[]] $modules
        )

    Write-Host "(Conda)Python3 identification: " -NoNewLine
    If( -Not (Get-Command python -ErrorAction SilentlyContinue) ){ $pyver = "" }
    Else {  $pyver = python -c "import sys; print(sys.version)" }# python version
    if(($pyver -like "*Miniconda*" -Or $pyver -like "*Anaconda*") -And ($pyver -like "*3.*")) {# right version 3. so install snakemake
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "snakemake identification: " -NoNewLine
        If( -Not (Get-Command snakemake -ErrorAction SilentlyContinue) ) {
            Write-Host "NOT FOUND" -ForegroundColor Red
            If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ) {
                conda update conda -y
                conda config --add channels bioconda
                pip install $modules
            }
            Else{
                $CONFIRM = Read-Host -Prompt "Do you want install snakemake and other dependecies? [y/n]"
                If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red }
                Else{
                    conda update conda -y 
                    conda config --add channels bioconda
                    pip install $modules
                }
            }
        }
        Else { Write-Host "FOUND" -ForegroundColor Green}
    }
    ElseIf(($pyver -like "*Miniconda*" -Or $pyver -like "*Anaconda*") -And ($pyver -like "*2.*")) {
        Write-Host "The Python version found is too old for snakemake" -ForegroundColor Red
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ) { get_python -add2path $add2path -modules $modules }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install a new version of Python, snakemake and other dependecies? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red }
            Else { get_python -add2path $add2path -modules $modules }
        }
    }
    Else{
        Write-Host "NOT FOUND" -ForegroundColor Red
        If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" ) { get_python -add2path $add2path -modules $modules }
        Else{
            $CONFIRM = Read-Host -Prompt "Do you want install snakemake and other dependecies? [y/n]"
            If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n') { Write-Host "Abort" -ForegroundColor Red }
            Else { get_python -add2path $add2path -modules $modules }
        }
    }
}
