. '.\core.ps1'

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