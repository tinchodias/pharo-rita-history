
"Load RS3 by hand because we need SpRoassalPresenter"
[ Metacello new
    baseline: 'Roassal3';
    repository: 'github://ObjectProfile/Roassal3:f0269f060a32174f1e2a094728b2d4263d6fb758';
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

