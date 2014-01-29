. '.\core.ps1'

$lock = Get-FileLock($lock_file)

if (-Not($lock))
{
	writeLog("Unable to lock!")
	Email-Log "FAILED! Scrub"
	exit 10
}

writeLog("`nRunning scrub")
writeLog("------------------------`n")

$log = Run-SnapRaidShadow "scrub"
writeLog $log

writeLog("`nStatus")
writeLog("------------------------`n")

$log = Run-SnapRaidShadow "status"
writeLog $log

Email-Log "Scrub"

$lock.close()