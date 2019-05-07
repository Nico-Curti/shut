#!/usr/bin/env pwsh

Function get_julia
{
  $julia_version = "1.1.0"
  $url_julia = "https://julialang-s3.julialang.org/bin/winnt/x64/1.1/julia-$julia_version-win64.exe"

  Write-Host Download julia from $url_julia
  $out = $url_julia.split('/')[-1]

  Start-BitsTransfer -source $url_julia

  $out

  Remove-Item $out_dir -Force -Recurse -ErrorAction SilentlyContinue
}

Function install_julia
{
  Param (
          [Parameter(Mandatory=$false)] [String] $confirm = ""
        )

  Write-Host "julia identification: " -NoNewLine
  If( -Not (Get-Command julia -ErrorAction SilentlyContinue) )
  { # julia not installed
    Write-Host "NOT FOUND" -ForegroundColor Red
    If( $confirm -eq "-y" -Or $confirm -eq "-Y" -Or $confirm -eq "yes" )
    {
      get_julia
    }
    Else
    {
      $CONFIRM = Read-Host -Prompt "Do you want install it? [y/n]"
      If($CONFIRM -eq 'N' -Or $CONFIRM -eq 'n')
      {
        Write-Host "Abort" -ForegroundColor Red
      }
      Else
      {
        get_julia
      }
    }
  }
  Else
  {
    Write-Host "FOUND" -ForegroundColor Green
  }
}

#install_julia -confirm -y
