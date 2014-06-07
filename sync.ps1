function DoActionProcessing()
{
	writeLog("Updating Shadow Copies")
	writeLog("------------------------`n")

	Update-ShadowConfig
	
	writeLog("`nRunning Diff")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "diff"
	writeLog $log	

	writeLog("`nRunning sync")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "sync"
	writeLog $log

	writeLog("`nStatus")
	writeLog("------------------------`n")

	$log = Run-SnapRaidShadow "status"
	writeLog $log

	Email-Log "Sync"
}

. '.\snapraid-shadowcopy\action.ps1'