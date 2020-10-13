
"Load RS3 by hand because we need SpRoassalPresenter"
[Metacello new
  baseline: 'Roassal3';
  repository: 'github://ObjectProfile/Roassal3';
  onConflictUseIncoming;
  load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

"Load project assuming the image is at build/"
dir := FileLocator imageDirectory parent pathString.
(IceRepositoryCreator new
	location: dir asFileReference; 
	createRepository) register.
Metacello new 
  baseline: 'Rita'; 
  repository: 'filetree://', dir;
  onConflictUseLoaded;
  onUpgradeUseLoaded;
  load.
