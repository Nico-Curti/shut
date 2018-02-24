#!/usr/bin/env pwsh

Function read_yaml
{
    Param (
            [String] $File
            )
    $yaml = @{}
    $nested = @{}
    Get-Content $File | ForEach-Object {
        $line = $_.Trim()
        If ($line.Length -ne 0){
            $key = $line.split(":")[0]
            $value = $line.split(":")[1]
            if($value -ne ""){
                $nested.Add($key.Trim(), $value.Trim())
            }
            Else{
                if($nested.Count -gt 0){
                    $yaml.Add($pkey, $nested)
                    $pkey = $key
                    $nested = @{}
                }
                Else{
                    $pkey = $key
                }
            }
        }
    }
    $yaml.Add($pkey, $nested)
    return $yaml
}
