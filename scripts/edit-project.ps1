. "$PSScriptRoot\common.ps1"

function editProject()
{
    Param(
		# This is the main wad file that UDB expects to initially load, containing the map.
        [parameter(Mandatory=$true)][string] $wad,
	
		# This is the map to load by default.
        [parameter(Mandatory=$true)][string] $map,
		
		# This is the configuration to load into UDB.
        [parameter(Mandatory=$true)][string] $configuration,
		
		# This is the IWAD that is optionally loaded.
        [parameter(Mandatory=$false)][string] $iwad,
		
		# This is the list of resources to load with the map, which should also be loaded when testing.
		[parameter(Mandatory=$false)][string[]] $resources,
		
		# This is the list of resources to load with the map, which should NOT be loaded when testing.
		[parameter(Mandatory=$false)][string[]] $udbResources)
	
	try
	{
		# The absolute url of the root of the project.
		$rootPath = (Get-Item .).FullName;
		
		# The absolute url of the location of the scripts folder.
		$scriptsPath = Join-Path -Path $rootPath -ChildPath "scripts";
		
		# The absolute url of the location of the source folder.
		$baseSourcePath = Join-Path -Path $rootPath -ChildPath "src";
		
		# The absolute url of the location of the main wad file.
		$wad = Join-Path -Path $baseSourcePath -ChildPath $wad;
		
		# Test the wad path.
		if (!(Test-Path -Path $wad -PathType Leaf))
		{
			throw "Wad file could not be found at `"$wad`". Please provide a valid path.";
		}
		
		# Determine the resources to open in UDB.
		$joinedResources = @();
		
		$loadResources = New-pathResources -baseSourcePath $baseSourcePath -resources $resources;
		foreach($resource in $loadResources)
		{
			$type = $resource.ResourceType;
			$path = $resource.Path;
			$joinedResources += "-resource $type `"$path`"";
		}

		#Write-Host "Project resources: $joinedResources";
		#Read-Host -Prompt "Press any key to continue"

		# Determine the location of Ultimate Doombuilder
		$udbExe = getFileFromShortcut -rootFolder $scriptsPath -shortcutFolder "UDB.lnk" -fileName "Builder.exe";
		
		# Determine the location of the IWAD to include.
		$iwadParameter = "";
		if ($iwad)
		{
			$iwadFile = getFileFromShortcut -rootFolder $scriptsPath -shortcutFolder "IWads.lnk" -fileName $iwad;
			$iwadParameter = "-resource wad `"$iwadFile`""
		}

		$argumentList = "`"$wad`" -map $map -cfg `"$configuration`" $iwadParameter $joinedResources";
		#Write-Host "Final argumentList: $argumentList";
		#Read-Host -Prompt "Press any key to continue";

		# Load UDB with the arguments.
		Start-Process -FilePath $udbExe -ArgumentList $argumentList;
	}
	catch
	{
		# Only log the line, the main script should catch and handle the rest.
		$line = $_.InvocationInfo.ScriptLineNumber
		Write-Host -ForegroundColor Red "Execution failed at line $line."
		throw;
	}
}