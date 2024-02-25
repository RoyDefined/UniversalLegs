. "$PSScriptRoot\scripts\edit-project.ps1"
. "$PSScriptRoot\scriptbase.ps1"

$wad = "ProjectMaps/map01.wad";
$map = "MAP01";
$configuration = "zandronum_DoomUDMF.cfg";
	
try
{
	editProject -wad $wad -map $map -configuration $configuration -iwad $iwad -resources $coreResources;
}
catch
{
	$message = $_.Exception.Message;
	Write-Host -ForegroundColor Red "Editing map failed: $message"
	Read-Host -Prompt "Press any key to exit"
	Exit
}