# Email current log
function Email-Log($action)
{
	Try
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
	Catch
	{}
}