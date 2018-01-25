
Function install_g++
{
    Param (
            [Parameter(Mandatory=$true, Position=0)]
            [String] $path,
            [Parameter(Mandatory=$true, Position=1)]
            [Bool] $add2path
            )
    Push-Location
    Set-Location $path
    
    Write-Host download g++ from https://sourceforge.net/projects/msys2/files/Base/i686/msys2-base-i686-20161025.tar.xz
    $url = "https://sourceforge.net/projects/msys2/files/Base/i686/msys2-base-i686-20161025.tar.xz"
    $Job = Start-BitsTransfer -Source $url -Asynchronous
    while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) `
    { sleep 5;} # Poll for status, sleep for 5 seconds, or perform an action.

    Switch($Job.JobState)
    {
        "Transferred" {Complete-BitsTransfer -BitsJob $Job}
        "Error" {$Job | Format-List } # List the errors.
        default {"Other action"} #  Perform corrective action.
    }

    cmake -E tar zxf msys2-base-i686-20161025.tar.xz
    Remove-Item msys2-base-i686-20161025.tar.xz -Force -Recurse -ErrorAction SilentlyContinue
    Set-Location msys32
    ./msys2_shell.cmd
    Start-Sleep -s 60
    ./usr/bin/pacman -Syuu --noconfirm
    ./usr/bin/pacman -S --noconfirm --needed base-devel mingw-w64-i686-toolchain #mingw-w64-x86_64-toolchain
    
    If( $add2path )
    {
        $env:PATH = $env:PATH + ";$PWD\mingw32\bin\;$PWD\usr\bin\"
        -join('$env:PATH = $env:PATH', " + `";$PWD\mingw32\bin\;$PWD\usr\bin\`"") | Out-File -FilePath "$env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
        Set-Variable -Name "CC" -Value "$PWD\mingw32\bin\gcc.exe"
        -join('Set-Variable -Name "CC" -Value ', "'$PWD\mingw32\bin\gcc.exe'") | Out-File -FilePath "$env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
        Set-Variable -Name "CXX" -Value "$PWD\mingw32\bin\g++.exe"
        -join('Set-Variable -Name "CXX" -Value ', "'$PWD\mingw32\bin\g++.exe'") | Out-File -FilePath "$env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    Set-Location ..

    Pop-Location
}