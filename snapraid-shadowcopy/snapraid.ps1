# Run SnapRaid using normal config
function Run-SnapRaid($cmd)
{
    $out = & $snapRaidExe $cmd -c "$config_base" -l "log.log" 2>&1 | out-string

    return $out
}

# Run SnapRaid using shadow copy config
function Run-SnapRaidShadow($cmd)
{
    $out = & $snapRaidExe $cmd -c "$config_shadow" -l "log.log" 2>&1 | out-string

    return $out
}