# SnapRaid-ShadowCopy

Powershell-script for updating shadow copies 
and using shadow copy to do sync instead of current state

Two main reasons for using this are:
* Files in use can be synchronised
* Removed files still exists in shadow copy, providing higher chance of success in case of disk failure

## Usage

* All disk must have shadow copy (system restore) enabled
* Rename "settings.sample.ini" as "settings.ini" and edit it with correct values (TODO: explain)
* Use sync.ps1 for sync instead of calling snapraid.exe directly (must run as administrator)

## Inner workings

1. Create new shadow copy for each drive
2. Copy configuration and replace direct paths of disk with path to shadow copy
3. Call SnapRaid using new configuration
4. Send email with output after sync is done