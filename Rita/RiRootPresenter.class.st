Class {
	#name : #RiRootPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'notebook'
	],
	#category : #'Rita-UI'
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

	self new
		model: RiRootModel newWithRegisteredRepositories;
		openWithSpec;
		withWindowDo: [ :window |
			window
				extent: 1000 @ 800;
				title: 'History Explorer' ]
]

{ #category : #initialization }
RiRootPresenter >> initializePresenters [
	notebook := self newNotebook.
	notebook addPage: self newHomePage
]

{ #category : #initialization }
RiRootPresenter >> newHomePage [
	^ SpNotebookPage
		title: 'Home'
		icon: (self iconNamed: #homeIcon)
		provider: [
			RiRepositoriesPresenter new
				model: model repositories;
				blockForOpenRepository: [ :aRiRepository |
					self openRepository: aRiRepository ];
				yourself ]
]

{ #category : #initialization }
RiRootPresenter >> newRepositoryPageFor: aRiRepository [
	^ SpNotebookPage
		title: aRiRepository name
		icon: (self iconNamed: #git)
		provider: [
			RiRepositoryAndElementPresenter new
				model: { #repository -> aRiRepository. #root -> model } asDictionary;
				blockForSpawn: [ :modelToSpawn | self openSpawnFor: modelToSpawn ];
				yourself ]
]

{ #category : #initialization }
RiRootPresenter >> openRepository: aRiRepository [
	| page |
	aRiRepository process.
	
	page := self newRepositoryPageFor: aRiRepository.
	notebook
		addPage: page;
		selectPage: page
]

{ #category : #initialization }
RiRootPresenter >> openSpawnFor: modelToSpawn [
	| page |
	page := SpNotebookPage
		title: 'Diff'
		icon: (self iconNamed: #objects)
		provider: [
			RiIceDiffPresenter new
				model: modelToSpawn;
				yourself ].

	notebook
		addPage: page;
		selectPage: page
]
