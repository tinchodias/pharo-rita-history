Class {
	#name : #RiRepositoryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'menuBar',
		'repository',
		'commentImageBuilder',
		'hiedraImageBuilder'
	],
	#category : #'Rita-UI'
}

{ #category : #examples }
RiRepositoryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
"		add: #menuBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #table;
		yourself
]

{ #category : #examples }
RiRepositoryPresenter class >> hiedraExample [
	<example>

	^ self openOnRepositoryNamed: 'Hiedra'
]

{ #category : #examples }
RiRepositoryPresenter class >> openOnRepositoryNamed: aName [
	| aRiRepository anIceRepository |
	anIceRepository := IceRepository registry
		detect: [ :each | each name beginsWith: aName ].
	aRiRepository := RiRepository new
		iceRepository: anIceRepository;
		process;
		yourself.

	(self on: aRiRepository)
		openWithSpec;
		withWindowDo: [ :window | 
			window
				extent: 1000 @ 900;
				title: aName ]
]

{ #category : #examples }
RiRepositoryPresenter class >> ritaExample [
	<example>

	^ self openOnRepositoryNamed: 'pharo-rita-history'
]

{ #category : #examples }
RiRepositoryPresenter class >> roassal3Example [
	<example>

	^ self openOnRepositoryNamed: 'Roassal3'
]

{ #category : #examples }
RiRepositoryPresenter class >> voyageExample [
	<example>

	^ self openOnRepositoryNamed: 'voyage'
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuForTable [
	| menu |
	self selectedRiElement ifNil: [ 1halt ].
	
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Inspect' target: self selectedRiElement selector: #inspect.
	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> initializeWidgets [

	table := self newTable.
	table
		showColumnHeaders;
		contextMenu: [ self contextMenuForTable ];
		addColumn: (ImageTableColumn evaluated: [ :item | hiedraImageBuilder morphAt: item ]) beNotExpandable;
		addColumn: ((SpStringTableColumn title: 'Author' evaluated: #author) width: 120);
		addColumn: (SpImageTableColumn title: 'Comment' evaluated: [:item | commentImageBuilder morphAt: item ]);
		addColumn: ((SpStringTableColumn title: 'Date' evaluated: #date) width: 120).

	commentImageBuilder := RiCommentImageBuilder new.
	hiedraImageBuilder := RiHiedraImageBuilder new.
	hiedraImageBuilder refreshWith: repository elements.
	table whenBuiltDo: [ :ann |
		hiedraImageBuilder setTable: ann widget ].
	
	table items: repository elements.

]

{ #category : #accessing }
RiRepositoryPresenter >> repository [
	^ repository
]

{ #category : #accessing }
RiRepositoryPresenter >> selectedRiElement [
	^ table selection selectedItem
]

{ #category : #initialization }
RiRepositoryPresenter >> setModelBeforeInitialization: aRiRepository [
	super setModelBeforeInitialization: aRiRepository.
	repository := aRiRepository.

]

{ #category : #accessing }
RiRepositoryPresenter >> table [
	^ table
]
