function DoActionProcessing()
{
	writeLog("Updating Shadow Copies")
	writeLog("------------------------`n")

	Update-ShadowConfig

	writeLog("`nRunning sync")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "sync"
	writeLog $log

	writeLog("`nRunning scrub")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow scrub -o 1
	writeLog $log

	writeLog("`nStatus")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "status"
	writeLog $log

	Email-Log "Sync and Scrub"
}

. '.\snapraid-shadowcopy\action.ps1'