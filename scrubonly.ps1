function DoActionProcessing()
{
	writeLog("`nRunning scrub")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow @("scrub", "-p", "100", "-o", "7")
	writeLog $log

	writeLog("`nStatus")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "status"
	writeLog $log

	Email-Log "Scrub"
}

. '.\snapraid-shadowcopy\action.ps1'