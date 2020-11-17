
"Load RS3 by hand because we need SpRoassalPresenter"
[ Metacello new
    baseline: 'Roassal3';
    repository: 'github://ObjectProfile/Roassal3';
    onConflictUseIncoming;
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

"IMPORTANT: we assume the image is at build/"
dir := FileLocator imageDirectory parent pathString.

"Load project"
Metacello new 
  baseline: 'Rita'; 
  repository: 'filetree://', dir;
  onConflictUseLoaded;
  onUpgradeUseLoaded;
  load.

"Add repository (for development)"
(IceRepositoryCreator new
	location: dir asFileReference; 
	createRepository) register.

