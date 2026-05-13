Class {
	#name : 'RiRootPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'notebook'
	],
	#category : 'Rita-UI-Spec2-Base',
	#package : 'Rita-UI',
	#tag : 'Spec2-Base'
}

{ #category : 'accessing' }
RiRootPresenter class >> defaultPreferredExtent [

	^ 1000 @ 800
]

{ #category : 'examples' }
RiRootPresenter class >> open [
	<script>

	^ self openWithApplication: RiSpApplication new
]

{ #category : 'examples' }
RiRootPresenter class >> openWithApplication: aSpApplication [

	^ (self newApplication: aSpApplication) open
]

{ #category : 'accessing' }
RiRootPresenter class >> taskbarIconName [

	^ #git
]

{ #category : 'accessing' }
RiRootPresenter class >> worldMenuItemOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Rita')
		parent: #Tools;
		action: [ self open ];
		icon: (self iconNamed: self taskbarIconName);
		help: 'Rita is a tool that helps developers to understand code changes in a git repository.';
		order: 1
]

{ #category : 'layout' }
RiRootPresenter >> defaultLayout [
	^ SpBoxLayout newVertical
		add: notebook;
"		add:
			(SpBoxLayout newHorizontal
				add: checkbox withConstraints: [ :constraints | constraints width: 20 ];
				add: 'Show dynamic presenter')
			withConstraints: [ :constraints | constraints height: self labelHeight ];"
		yourself
]

{ #category : 'initialization' }
RiRootPresenter >> initialize [

	super initialize.

	self model: RiRootModel newWithRegisteredRepositories
]

{ #category : 'initialization' }
RiRootPresenter >> initializePresenters [

	super initializePresenters.
	notebook := self newNotebook.
	notebook addPage: self newHomePage
]

{ #category : 'private' }
RiRootPresenter >> newHomePage [

	^ SpNotebookPage title: 'Home' icon: (self iconNamed: #homeIcon) provider: [
			  RiRepositoryListPresenter new
				  model: model repositories;
				  whenOpeningRepositoryDo: [ :aRiRepository | self openRepository: aRiRepository ];
				  yourself ]
]

{ #category : 'private' }
RiRootPresenter >> newRepositoryPageFor: aRiRepository [

	^ SpNotebookPage title: aRiRepository name icon: (self iconNamed: #git) provider: [
			  RiRepositoryMasterDetailPresenter new
				  model: {
						  (#repository -> aRiRepository).
						  (#root -> model).
						  (#aesthetics -> model aesthetics).
						  (#blockForSpawn -> [ :modelToSpawn | self openSpawnFor: modelToSpawn ]) } asDictionary;
				  yourself ]
]

{ #category : 'private' }
RiRootPresenter >> newSpawnPageFor: modelToSpawn [

	^ SpNotebookPage title: (self titleForSpawnPage: modelToSpawn) icon: (self iconNamed: #git) provider: [
			  RiFullDiffPresenter new
				  model: modelToSpawn;
				  yourself ]
]

{ #category : 'private' }
RiRootPresenter >> openPage: anObject ifAbsentBuildWith: aBlock [
	"Ensure a notebook's page is open (and selected)."

	| page |
	notebook pages allButFirst
		detect: [ :each | each activePresenter isForRepository: anObject ]
		ifFound: [ :foundPage | ^ notebook selectPage: foundPage ].

	page := aBlock value.
	page beCloseable.
	notebook
		addPage: page;
		selectPage: page
]

{ #category : 'private' }
RiRootPresenter >> openRepository: aRiRepository [

	self openPage: aRiRepository ifAbsentBuildWith: [ self newRepositoryPageFor: aRiRepository ]
]

{ #category : 'private' }
RiRootPresenter >> openSpawnFor: modelToSpawn [

	self openPage: modelToSpawn ifAbsentBuildWith: [ self newSpawnPageFor: modelToSpawn ]
]

{ #category : 'private' }
RiRootPresenter >> titleForSpawnPage: modelToSpawn [
	^ '{1}: {2}'
		format:
			{(modelToSpawn at: #repository) name.
			(modelToSpawn at: #iceDiff) ritaShortId}
]

{ #category : 'initialization' }
RiRootPresenter >> windowTitle [

	^ 'History Explorer'
]
