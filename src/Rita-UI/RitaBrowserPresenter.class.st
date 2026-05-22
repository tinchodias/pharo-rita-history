"
I am the root presenter of Rita. 

I'll open on a list of repositories that are accessible in `Iceberg`. When the user select one of the repository, I'll open a tab displaying some details on the repository such as its history and a visualization of changes applied on the project. 

Visualization can be a powerful tool compared to text in order to review the impact of a change.

TODOX Document the spawn pages (for now I do not know what they are)
"
Class {
	#name : 'RitaBrowserPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'notebook'
	],
	#category : 'Rita-UI-Spec2-Base',
	#package : 'Rita-UI',
	#tag : 'Spec2-Base'
}

{ #category : 'accessing' }
RitaBrowserPresenter class >> defaultPreferredExtent [

	^ 1000 @ 800
]

{ #category : 'examples' }
RitaBrowserPresenter class >> open [
	<script>

	^ self openWithApplication: RiSpApplication new
]

{ #category : 'examples' }
RitaBrowserPresenter class >> openWithApplication: aSpApplication [

	^ (self newApplication: aSpApplication) open
]

{ #category : 'accessing' }
RitaBrowserPresenter class >> taskbarIconName [

	^ #git
]

{ #category : 'accessing' }
RitaBrowserPresenter class >> worldMenuItemOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Rita')
		parent: #Tools;
		action: [ self open ];
		icon: (self iconNamed: self taskbarIconName);
		help: 'Rita is a tool that helps developers to understand code changes in a git repository.';
		order: 1
]

{ #category : 'layout' }
RitaBrowserPresenter >> defaultLayout [
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
RitaBrowserPresenter >> initialize [

	super initialize.

	self model: RiRootModel newWithRegisteredRepositories
]

{ #category : 'initialization' }
RitaBrowserPresenter >> initializePresenters [

	super initializePresenters.
	notebook := self newNotebook.
	notebook addPage: self newHomePage
]

{ #category : 'private' }
RitaBrowserPresenter >> newHomePage [

	^ SpNotebookPage title: 'Home' icon: (self iconNamed: #homeIcon) provider: [
			  RiRepositoryListPresenter new
				  model: model repositories;
				  whenOpeningRepositoryDo: [ :aRiRepository | self openRepository: aRiRepository ];
				  yourself ]
]

{ #category : 'private' }
RitaBrowserPresenter >> newRepositoryPageFor: aRiRepository [

	^ SpNotebookPage title: aRiRepository name icon: (self iconNamed: #git) provider: [
			  RiRepositoryPresenter new
				  model: {
						  (#repository -> aRiRepository).
						  (#root -> model).
						  (#blockForSpawn -> [ :modelToSpawn | self openSpawnFor: modelToSpawn ]) } asDictionary;
				  yourself ]
]

{ #category : 'private' }
RitaBrowserPresenter >> newSpawnPageFor: modelToSpawn [

	^ SpNotebookPage
		  title: (self titleForSpawnPage: modelToSpawn)
		  icon: (self iconNamed: #git)
		  provider: [ self instantiate: RiFullDiffPresenter on: modelToSpawn ]
]

{ #category : 'private' }
RitaBrowserPresenter >> openPage: anObject ifAbsentBuildWith: aBlock [
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
RitaBrowserPresenter >> openRepository: aRiRepository [

	self openPage: aRiRepository ifAbsentBuildWith: [ self newRepositoryPageFor: aRiRepository ]
]

{ #category : 'private' }
RitaBrowserPresenter >> openSpawnFor: modelToSpawn [

	self openPage: modelToSpawn ifAbsentBuildWith: [ self newSpawnPageFor: modelToSpawn ]
]

{ #category : 'private' }
RitaBrowserPresenter >> titleForSpawnPage: modelToSpawn [
	^ '{1}: {2}'
		format:
			{(modelToSpawn at: #repository) name.
			(modelToSpawn at: #iceDiff) ritaShortId}
]

{ #category : 'initialization' }
RitaBrowserPresenter >> windowTitle [

	^ 'History Explorer'
]
