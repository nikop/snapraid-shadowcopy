<#
Base for actions
#>

$path = Split-Path -parent $PSCommandPath
. "$path\main.ps1"

writeLog("SnapRaid-ShadowCopy v0.1")
writeLog("------------------------`n")

$lock = Get-FileLock($lock_file)

Write-Host $lock_file

if (-Not($lock))
{
	writeLog("Unable to lock!")
	Email-Log "FAILED!"
	exit 10
}

# Ensure there is shadowed config
#if ( -Not( Test-Path $config_shadow ) )
#{
    Update-ShadowConfig
#}

DoActionProcessing

$lock.close()