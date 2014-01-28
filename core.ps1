. '.\ini.ps1'
. '.\shadowcopy.ps1'

# Logging
$global:message = ""

function writeLog($txt)
{
    Write-Host $txt
    $global:message = $global:message + "`n" + $txt
}
# /Logging

function Get-FileLock($name)
{
    if (-Not(Test-Path $name))
    {
        Set-Content $name ""
    }
	$file = 0
	
	try {
		$file = [System.IO.File]::Open($name, 'Open', 'ReadWrite', 'None')
	}
	catch {
		$file = 0
	}
	
	return $file
}

$config = Get-IniContent('.\settings.ini')

# EXE of SnapRaid
$snapRaidExe = $config["SnapRaid"]["path"] + "\snapraid.exe"

# Path to config
$config_base = $config["SnapRaid"]["config"]
# Path to config with ShadowCopy paths
$config_shadow = $config["SnapRaid"]["config_shadow"]

$min_age = $config["ShadowCopy"]["min_age"]
# Lock File
$lock_file = $config["SnapRaid"]["lock_file"]

# Current Time (for consistency)
$now = Get-Date

# Update config
function Update-ShadowConfig()
{
    $file = New-Object System.IO.StreamWriter $config_shadow
    
    foreach ( $l in Get-Content $config_base )
    {
        # Format: disk d1 D:\
        if ( $l.StartsWith("disk") )
        {
            $tmp = $l.Split(" ")

            writeLog("Cheking shadow copy for: " + $tmp[2])

            $sc = Get-LatestShadowCopy($tmp[2])
            
            $updateShadowCopy = 0

            if ($sc)
            {
                $InstallDate = [system.management.managementdatetimeconverter]::todatetime(($sc).InstallDate)

                # Check age of Shadow Copy
                if ($now.Subtract($InstallDate).TotalHours -gt $min_age)
                {
                    $updateShadowCopy = 1
                }
            }
            else
            {
                $updateShadowCopy = 1
            }

            # Update Shadow Copy
            if ($updateShadowCopy)
            {
                writeLog("Updating")
                
                $sc = Update-ShadowCopy($tmp[2])
                
                writeLog("Update Done")
            }
            else
            {
                writeLog("Skipping, less than $min_age hours old")
            }

            $file.WriteLine("disk " + $tmp[1] + " " + $sc.DeviceObject + "\")
        }
        else
        {
            $file.WriteLine($l)
        }
    }

    $file.Close()
}

# Run SnapRaid using normal config
function Run-SnapRaid($cmd)
{
    $out = & $snapRaidExe $cmd -c "$config_base" 2>&1 | out-string

    return $out
}

# Run SnapRaid using shadow copy config
function Run-SnapRaidShadow($cmd)
{
    $out = & $snapRaidExe $cmd -c "$config_shadow" 2>&1 | out-string

    return $out
}

# Ensure there is shadowed config
if ( -Not( Test-Path $config_shadow ) )
{
    Update-ShadowConfig
}

# Email current log
function Email-Log($action)
{
    $secpasswd 		= ConvertTo-SecureString $config["email"]["p"] -AsPlainText -Force
    $mycreds 		= New-Object System.Management.Automation.PSCredential ($config["email"]["u"], $secpasswd)

    send-mailmessage `
		-to $config["email"]["to"] `
		-from $config["email"]["from"] `
		-subject "[SnapRaid] $action" `
		-body $global:message `
		-smtpserver smtp.gmail.com `
		-usessl `
		-credential $mycreds `
		-port 587
}

writeLog("SnapRaid-ShadowCopy v0.1")
writeLog("------------------------`n")