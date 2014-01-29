$config = Get-IniContent('.\settings.ini')

function Config
{
	param(
		$section,
		$variable
	)
	
	return $config[$section][$variable]
}