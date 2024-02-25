. "$PSScriptRoot\scripts\publish-project.ps1"

$mapsProjectPath = "UniversalLegs";
$logsPath = "logs";
$engine = "zandronum";

try
{
	invokePublishTool -projectPath $mapsProjectPath -logOutput $logsPath -compileWith "bcc" -defines "dev" -engine "zandronum"
}
catch
{
	$message = $_.Exception.Message;
	Write-Host -ForegroundColor Red "Tool invokation failed: $message"
	Read-Host -Prompt "Press any key to exit"
	Exit
}