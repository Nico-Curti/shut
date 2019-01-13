#!/usr/bin/env pwsh

Function get_python
{
  Param (
          [Bool] $add2path,
          [Parameter(Mandatory=$false, ValueFromRemainingArguments=$false)]
          [String[]] $modules
        )

  $url_python = "https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Windows-x86_64.exe"

  Write-Host "Download Python from "$url_python
  $exec = $url_python.split('/')[-1]
  $conda = $exec.split('-')[0] # miniconda/anaconda

  Invoke-WebRequest -Uri $url_python -OutFile $exec

  Write-Host $conda will be install and it will set as default python
  cmd.exe /c "start /wait `"`" $exec /InstallationType=JustMe /RegisterPython=0 /S /D=%cd%\$conda"
  Remove-Item $conda -Force -ErrorAction SilentlyContinue
  $conda = $conda.ToLower()
  If ( $add2path )
  {
    $Documents = [Environment]::GetFolderPath('MyDocuments')
    -join('$env:PATH = $env:PATH', " + `";$PWD\$conda;$PWD\$conda\Scripts;$PWD\$conda\Library\bin;$PWD\$conda\Library\usr\bin;$PWD\$conda\Library\mingw-w64\bin;`"") | Out-File -FilePath "$env:UserProfile\$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
  }
  #$env:PATH = $env:PATH + ";$PWD\$conda;$PWD\$conda\Scripts;$PWD\$conda\Library\bin;$PWD\$conda\Library\usr\bin;$PWD\$conda\Library\mingw-w64\bin;"
  . "$PROFILE"

  conda.exe update conda -y
  conda.exe config --add channels bioconda
  Foreach ($i in $modules)
  {
    pip.exe install $i
  }
}


Function install_python
{
  Param (
          [Bool] $add2path,
          [Parameter(Mandatory=$false)] [String] $confirm = "",
          [Parameter(Mandatory=$false, ValueFromRemainingArguments=$false)] [String[]] $modules
        )

  Write-Host "(Conda) Python3 identification: " -NoNewLine
  If( -Not (Get-Command python -ErrorAction SilentlyContinue) )
  {
    $pyver = ""
  }
  Else
  {
    $pyver = python -c "import sys; print(sys.version)"
  }# python version

  if(($pyver -like "*Miniconda*" -Or $pyver -like "*Anaconda*") -And ($pyver -like "*3.*"))
  {# right version 3. so install snakemake
    Write-Host "FOUND" -ForegroundColor Green
    conda.exe update conda -y
    conda.exe config --add channels bioconda
    Foreach ($i in $modules)
    {
      pip.exe install $i
    }
  }
  ElseIf(($pyver -like "*Miniconda*" -Or $pyver -like "*Anaconda*") -And ($pyver -like "*2.*"))
  {
    Write-Host "The Python version found is too old for snakemake" -ForegroundColor Red
    If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" )
    {
      get_python -add2path $add2path -modules $modules
    }
    Else
    {
      $CONFIRM = Read-Host -Prompt "Do you want install a new version of Python, snakemake and other dependecies? [y/n]"
      If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n')
      {
        Write-Host "Abort" -ForegroundColor Red
      }
      Else
      {
        get_python -add2path $add2path -modules $modules
      }
    }
  }
  Else
  {
    Write-Host "NOT FOUND" -ForegroundColor Red
    If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" )
    {
      get_python -add2path $add2path -modules $modules
    }
    Else
    {
      $CONFIRM = Read-Host -Prompt "Do you want install snakemake and other dependecies? [y/n]"
      If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n')
      {
        Write-Host "Abort" -ForegroundColor Red
      }
      Else
      {
        get_python -add2path $add2path -modules $modules
      }
    }
  }
}

#install_python -add2path $true -confirm -y
