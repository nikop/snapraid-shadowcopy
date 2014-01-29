$global:message = ""

function writeLog($txt)
{
    Write-Host $txt
    $global:message = $global:message + "`n" + $txt
}