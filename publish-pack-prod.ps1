. "$PSScriptRoot\scripts\publish-project.ps1"

$coreProjectPath = "UniversalLegs";
$logsPath = "logs";
$engine = "zandronum";
$buildPath = "build";

try
{
	invokePublishTool -projectPath $coreProjectPath -packToOutput $buildPath -logOutput $logsPath -todoAt $logsPath -compileWith "bcc" -engine $engine -tempProject $true -removeAcs $true -removeUnrelated $true -removeEmpty $true;
}
catch
{
	$message = $_.Exception.Message;
	Write-Host -ForegroundColor Red "Tool invokation failed: $message"
	Read-Host -Prompt "Press any key to exit"
	Exit
}