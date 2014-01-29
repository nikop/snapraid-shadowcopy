. '.\core.ps1'

$lock = Get-FileLock($lock_file)

Write-Host $lock_file

if (-Not($lock))
{
	writeLog("Unable to lock!")
	Email-Log "FAILED! Sync"
	exit 10
}

writeLog("Updating Shadow Copies")
writeLog("------------------------`n")

Update-ShadowConfig

writeLog("`nRunning sync")
writeLog("------------------------`n")

$log = Run-SnapRaidShadow "sync"
writeLog $log

writeLog("`nStatus")
writeLog("------------------------`n")

$log = Run-SnapRaidShadow "status"
writeLog $log

Email-Log "Sync"

$lock.close()