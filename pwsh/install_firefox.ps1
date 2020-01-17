#!/usr/bin/env pwsh

Function get_firefox
{
  Param (
          [Bool] $add2path
        )

  $url_firefox = "https://download.mozilla.org/?product=firefox-latest&os=win64"

  $out_file = "Firefox_Setup_72.0.1.exe"

  Write-Host download firefox from $url_firefox

  Invoke-WebRequest -Uri $url_firefox -OutFile $out_file

  $out_file

  Remove-Item $out_file -Force -Recurse -ErrorAction SilentlyContinue
}


Function install_firefox
{
  Param (
          [Bool] $add2path,
          [Parameter(Mandatory=$false)] [String] $confirm = ""
        )

  # Firefox download
  Write-Host "Firefox identification: " -NoNewLine
  If( -Not (Get-Command firefox -ErrorAction SilentlyContinue) )
  { # firefox not installed
    Write-Host "FOUND" -ForegroundColor Red
    If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" )
    {
      get_firefox -add2path $add2path
    }
    Else
    {
      $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
      If($CONFIRM -eq "N" -Or $CONFIRM -eq "n")
      {
        Write-Host "Abort" -ForegroundColor Red
      }
      Else
      {
        get_firefox -add2path $add2path
      }
    }
  }
  Else
  {
    Write-Host "FOUND" -ForegroundColor Green
  }

}

#install_firefox -add2path $true -confirm -y
