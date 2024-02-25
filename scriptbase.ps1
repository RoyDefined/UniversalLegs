# Specifies the core resources to load into UDB + build.
$coreResources = @(
	'UniversalLegs'
);

# Specifies the iwad to load alongside the resources.
$iwad = "doom2.wad";

# Specifies the resources to build, combining the core and map resources.
$buildResources = $coreResources + $mapResources;

# Specifies the resources to load from the build folder when playing.
$buildFileResources = $coreResources + $mapResources;
for ($i = 0; $i -lt $buildFileResources.Count; $i++) {
    $buildFileResources[$i] += ".pk3";
}

# The joined array of strings for the maps to load.
$mapsJoined = @();
foreach($map in $maps) {
	$mapsJoined += '+addmap ' + $map;
}

# The joined array of strings for 63 bots to be added.
$botsJoined = @();
for ($i = 0; $i -lt 64; $i++) {
    $botsJoined += '+addbot HumanGuy';
}