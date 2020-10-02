Class {
	#name : #RiRootPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'notebook'
	],
	#category : #'Rita-UI-Spec2-Base'
}

{ #category : #specs }
RiRootPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #notebook;
"		add:
			(SpBoxLayout newHorizontal
				add: #checkbox withConstraints: [ :constraints | constraints width: 20 ];
				add: 'Show dynamic presenter')
			withConstraints: [ :constraints | constraints height: self labelHeight ];"
		yourself
]

{ #category : #examples }
RiRootPresenter class >> open [
	<script>

	^ self openWithApplication: RiSpApplication new
]

{ #category : #examples }
RiRootPresenter class >> openWithApplication: aSpApplication [
	^ (self newApplication: aSpApplication) openWithSpec
]

{ #category : #accessing }
RiRootPresenter class >> taskbarIconName [

	^ #git
]

{ #category : #accessing }
RiRootPresenter class >> worldMenuItemOn: aBuilder [
	<worldMenu>

	(aBuilder item: 'Rita')
		parent: #Tools;
		action: [ self open ];
		icon: self taskbarIcon;
		help: 'Experimental UI to browse Iceberg repositories';
		order: 0.5
]

{ #category : #initialization }
RiRootPresenter >> initialize [
	super initialize.

	self model: RiRootModel newWithRegisteredRepositories
]

{ #category : #initialization }
RiRootPresenter >> initializePresenters [
	notebook := self newNotebook.
	notebook addPage: self newHomePage
]

{ #category : #initialization }
RiRootPresenter >> initializeWindow: aSpWindowPresenter [
	aSpWindowPresenter
		initialExtent: 1000 @ 800;
		title: 'History Explorer'
]

{ #category : #private }
RiRootPresenter >> newHomePage [
	^ SpNotebookPage
		title: 'Home'
		icon: (self iconNamed: #homeIcon)
		provider: [
			RiRepositoryListPresenter new
				model: model repositories;
				blockForOpenRepository: [ :aRiRepository |
					self openRepository: aRiRepository ];
				blockForOpenPullRequests: [ :anIceRemote |
					self openPullRequestsOf: anIceRemote ];
				yourself ]
]

{ #category : #private }
RiRootPresenter >> newPullRequestsPageFor: anIceRemote [
	^ SpNotebookPage
		title: ''
		icon: (self iconNamed: #github)
		provider: [
			(self instantiate: RiPullRequestMasterDetailPresenter)
				model: { 
					#githubRemote -> anIceRemote. 
					#repository -> anIceRemote localRepository.
					#root -> model.
					#aesthetics -> model aesthetics.
					#blockForSpawn -> [ :modelToSpawn | self openSpawnFor: modelToSpawn ].
					} asDictionary;
				yourself ]
]

{ #category : #private }
RiRootPresenter >> newRepositoryPageFor: aRiRepository [
	^ SpNotebookPage
		title: ''
		icon: (self iconNamed: #git)
		provider: [
			RiRepositoryMasterDetailPresenter new
				model: { 
					#repository -> aRiRepository. 
					#root -> model.
					#aesthetics -> model aesthetics.
					#blockForSpawn -> [ :modelToSpawn | self openSpawnFor: modelToSpawn ]
					} asDictionary;
				yourself ]

]

{ #category : #private }
RiRootPresenter >> newSpawnPageFor: modelToSpawn [
	^ SpNotebookPage
		title: ''
		icon: (self iconNamed: #git)
		provider: [
			RiFullDiffPresenter new
				model: modelToSpawn;
				yourself ]
]

{ #category : #private }
RiRootPresenter >> openPage: anObject title: aString ifAbsentBuildWith: aBlock [
	"Ensure a notebook's page is open (and selected)."

	| page |
	self flag: #todo. "Use model as key instead of the title, to know if it's already a page."
	notebook pages
		detect: [ :each | each title = aString ]
		ifFound: [ :foundPage | ^ notebook selectPage: foundPage ].
	
	page := aBlock value.
	page title: aString.
	notebook
		addPage: page;
		selectPage: page
]

{ #category : #private }
RiRootPresenter >> openPullRequestsOf: anIceRemote [
	self
		openPage: anIceRemote
		title: (self titleForPullRequestsPage: anIceRemote)
		ifAbsentBuildWith: [ self newPullRequestsPageFor: anIceRemote ]
]

{ #category : #private }
RiRootPresenter >> openRepository: aRiRepository [
	self
		openPage: aRiRepository
		title: (self titleForRepositoryPage: aRiRepository)
		ifAbsentBuildWith: [ self newRepositoryPageFor: aRiRepository ]
]

{ #category : #private }
RiRootPresenter >> openSpawnFor: modelToSpawn [
	self
		openPage: modelToSpawn
		title: (self titleForSpawnPage: modelToSpawn)
		ifAbsentBuildWith: [ self newSpawnPageFor: modelToSpawn ]
]

{ #category : #private }
RiRootPresenter >> titleForPullRequestsPage: anIceRemote [
	^ 'Pull Requests on {1}' format: {anIceRemote displayString}
]

{ #category : #private }
RiRootPresenter >> titleForRepositoryPage: aRiRepository [
	^ aRiRepository name
]

{ #category : #private }
RiRootPresenter >> titleForSpawnPage: modelToSpawn [
	^ '{1}: {2}'
		format:
			{(modelToSpawn at: #repository) name.
			(modelToSpawn at: #iceDiff) ritaShortId}
]
