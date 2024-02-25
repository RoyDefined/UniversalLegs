# This is used to traverse the shortcut files.
$shell = New-Object -ComObject WScript.Shell;

function getFileFromShortcut()
{
    Param(
        [parameter(Mandatory=$true)][string] $rootFolder,
        [parameter(Mandatory=$true)][string] $shortcutFolder,
        [parameter(Mandatory=$true)][string] $fileName)

    $shortcutPath = Join-Path -Path $rootFolder -ChildPath "/$shortcutFolder"
    #Write-Host "Shortcut path for ${shortcutFolder}: $shortcutPath";

	if (!(Test-Path -Path $shortcutPath -PathType Leaf))
	{
		throw "${shortcutFolder} shortcut folder was not found at `"$shortcutPath`". Please create a shortcut file to use.";
	}
	
    $folderPath = $shell.CreateShortcut($shortcutPath).TargetPath
    $filePath = Join-Path -Path $folderPath -ChildPath "/$fileName"
    #Write-Host "File path: $filePath";

	if (!(Test-Path -Path $filePath -PathType Leaf))
	{
		throw "$fileName was not found at `"$filePath`". Please create a shortcut to the file folder to use, and point it to the folder containing $fileName.";
	}

    return $filePath;
}

function New-pathResources
{
    Param(
		[parameter(Mandatory)][string] $baseSourcePath,
        [parameter(Mandatory)][string[]] $resources)
		
	foreach($resource in $resources)
	{
		$resourcePath = Join-Path -Path $baseSourcePath -ChildPath $resource;
		$type = "";
		
		# Add the resource as a file or folder.
		if (Test-Path -Path $resourcePath -PathType Leaf)
		{
			# Determine the extension of the file. Only `wad` or `pk3` is supported.
			if ($resourcePath.EndsWith(".wad"))
			{
				$type = "wad";
			}
			elseif ($resourcePath.EndsWith(".pk3"))
			{
				$type = "pk3";
			}
			else
			{
				throw "Failed to determine resource type `"$resourcePath`" as extension `"$fileExtension`" is not supported.";
			}
		}
		elseif (Test-Path -Path $resourcePath -PathType Container)
		{
			$type = "dir";
		}
		else
		{
			throw "Failed to determine resource type `"$resourcePath`" as path does not exist.";
		}
		
		[PSCustomObject]@{
            Path = $resourcePath
            ResourceType = $type
        }
	}
}