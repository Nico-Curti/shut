
Function install_python
{
    Param (
            [Parameter(Mandatory=$true, Position=0)]
            [String] $url,
            [Parameter(Mandatory=$true, Position=1)]
            [Bool] $add2path,
            [Parameter(ValueFromRemainingArguments=$false)]
            [String[]] $modules
            )
    Write-Host "Download Python from "$url
    $exec = $url.split('/')[-1]
    $conda = $exec.split('-')[0] # miniconda/anaconda

    $Job = Start-BitsTransfer -Source $url -Asynchronous
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
        $env:PATH = $env:PATH + ";$env:UserProfile\$conda;$env:UserProfile\$conda\Scripts;$env:UserProfile\$conda\Library\bin;$env:UserProfile\$conda\Library\usr\bin;$env:UserProfile\$conda\Library\mingw-w64\bin;"
        -join('$env:PATH = $env:PATH', " + `";$env:UserProfile\$conda;$env:UserProfile\$conda\Scripts;$env:UserProfile\$conda\Library\bin;$env:UserProfile\$conda\Library\usr\bin;$env:UserProfile\$conda\Library\mingw-w64\bin;`"") | Out-File -FilePath "$env:UserProfile\$Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Append -Encoding ASCII
    }
    conda update conda -y
    conda config --add channels bioconda
    Foreach ($i in $modules)
    {
        pip install $i
    }
}
