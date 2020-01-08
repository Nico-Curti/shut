#!/usr/bin/env pwsh

Function get_cmake
{
  Param (
          [Bool] $add2path
        )
  $cmake_version = "3.16.2"
  $cmake_up_version = $cmake_version.Substring(0, $cmake_version.Length - 2)
  $url_cmake = "https://cmake.org/files/v$cmake_up_version/cmake-$cmake_version-win64-x64.zip"

  Write-Host "Download CMAKE from "$url_cmake
  $out_dir = $url_cmake.split('/')[-1]
  $out = $out_dir.Substring(0, $out_dir.Length - 4) # remove extension (.zip)

  Invoke-WebRequest -Uri $url_cmake -OutFile $out_dir

  Write-Host unzip $out_dir
  Expand-Archive $out_dir -DestinationPath $path/cmake
  If ( $add2path )
  {
    $Documents = [Environment]::GetFolderPath('MyDocuments')
    -join('$env:PATH = $env:PATH', " + `";$PWD\cmake\$out\bin\`"") | Out-File -FilePath "$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
  }
  #$env:PATH = $env:PATH + ";$PWD\cmake\$out\bin\"
  Remove-Item $out_dir -Force -Recurse -ErrorAction SilentlyContinue
}

Function install_cmake
{
  Param (
          [Bool] $add2path,
          [Parameter(Mandatory=$false)] [String] $confirm = ""
        )

  Write-Host "cmake identification: " -NoNewLine
  If( -Not (Get-Command cmake -ErrorAction SilentlyContinue) )
  { # cmake not installed
    Write-Host "NOT FOUND" -ForegroundColor Red
    If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" )
    {
      get_cmake -add2path $true
    }
    Else
    {
      $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
      If( $CONFIRM -eq "N" -Or $CONFIRM -eq "n" )
      {
        Write-Host "Abort" -ForegroundColor Red
      }
      Else
      {
        get_cmake -add2path $true
      }
    }
  }
  Else
  {
    Write-Host "FOUND" -ForegroundColor Green
  }
}

#install_cmake -add2path $true -confirm -y
