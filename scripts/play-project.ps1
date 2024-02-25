. "$PSScriptRoot\common.ps1"

function playProject()
{
    Param(
		# The map that should be loaded initially.
        [parameter(Mandatory=$false)][string] $map,
		
		# This is the source folder where the project can be found to load.
		[parameter(Mandatory=$false)][string] $sourceFolder,
		
		# Specifies the output where logging should log into.
		[parameter(Mandatory=$false)][string] $logOutput,
		
		# The game mode that must be loaded initially.
		[parameter(Mandatory=$false)][string] $gameMode,
		
		# A config containing configuration to start the game.
		[parameter(Mandatory=$false)][string] $config,
		
		# If `true`, start a local server.
		[parameter(Mandatory=$false)][boolean] $online,
		
		# Extra parameters to load.
		[parameter(Mandatory=$false)][string] $extraParameters,
		
		# This is the IWAD that is optionally loaded.
        [parameter(Mandatory=$false)][string] $iwad,
		
		# This is the list of resources to load.
		[parameter(Mandatory=$false)][string[]] $resources)
	
	try
	{
		# The absolute url of the root of the project.
		$rootPath = (Get-Item .).FullName;
		
		# The absolute url of the location of the scripts folder.
		$scriptsPath = Join-Path -Path $rootPath -ChildPath "scripts";
		
		# The absolute url of the location of the source folder.
		$baseSourcePath = Join-Path -Path $rootPath -ChildPath "src";
		if ($sourceFolder) {
			$baseSourcePath = Join-Path -Path $rootPath -ChildPath $sourceFolder;
		}
		
		# Determine the resources to open in UDB.
		$joinedResources = @();
		$loadResources = New-pathResources -baseSourcePath $baseSourcePath -resources $resources;
		foreach($resource in $loadResources)
		{
			$path = $resource.Path;
			$joinedResources += "-file `"$path`"";
		}

		# Determine the location of the engine.
		$engineExecutable = getFileFromShortcut -rootFolder $scriptsPath -shortcutFolder "Engine.lnk" -fileName "Zandronum.exe";
		
		# Determine the location of the IWAD to include.
		$iwadParameter = "";
		if ($iwad)
		{
			$iwadFile = getFileFromShortcut -rootFolder $scriptsPath -shortcutFolder "IWads.lnk" -fileName $iwad;
			$iwadParameter = "-iwad `"$iwadFile`""
		}
		
		# Set log file outputs.
		if (!$logOutput) {
			$logOutput = "logs";
		}
		$logOutput = Join-Path -Path $rootPath -ChildPath (Join-Path -Path $logOutput -ChildPath "log");
		
		if ($gameMode) {
			$gameMode = "+$gameMode true"
		}
		
		$onlineString = "";
		if ($online) {
			$onlineString = "-host -netmode 1";
		}
		
		$mapString = "";
		if ($map) {
			$mapString = "+map $map";
		}
		
		# Add config if specified
		$configPath = "";
		if ($config) {
			$configPath = "+exec " + (Join-Path -Path $rootPath -ChildPath $config);
		}
		
		# Extra parameters.
		if (!$extraParameters) {
			$extraParameters = "";
		}

		$argumentList = "$iwadParameter $joinedResources -skill 4 -stdout $gameMode +logfile `"$logOutput`" $mapString $onlineString $extraParameters $configPath";
		
		#Write-Host "Final argumentList: $argumentList";
		#Read-Host -Prompt "Press any key to continue"

		$null = New-Item -ItemType Directory -Force -Path (Split-Path -Path $logOutput);

		# Load UDB with the arguments.
		Start-Process -FilePath $engineExecutable -ArgumentList $argumentList;
	}
	catch
	{
		# Only log the line, the main script should catch and handle the rest.
		$line = $_.InvocationInfo.ScriptLineNumber
		Write-Host -ForegroundColor Red "Execution failed at line $line."
		throw;
	}
}