#!/usr/bin/env pwsh

Function get_pip
{
  $url_pip = "https://bootstrap.pypa.io/get-pip.py"
  Write-Host "Download get-pip from $url_pip"

  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri $url_pip -OutFile $PWD/get-pip.py

  Write-Host "Run get-pip"
  If( -Not (Get-Command python -ErrorAction SilentlyContinue) )
  {
    Write-Host "python NOT FOUND"; exit
  }
  Else
  {
    python $PWD\get-pip.py
  }
}

#get_pip
