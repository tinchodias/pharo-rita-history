"
I am a Spec2 presenter for RiRepository objects.

"
Class {
	#name : #RiRepositoryPresenter,
	#superclass : #RiPresenter,
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
RiRepositoryPresenter class >> mongotalkExample [
	<example>

	^ self openOnRepositoryNamed: 'mongotalk'
]

{ #category : #examples }
RiRepositoryPresenter class >> openOnRepositoryNamed: aName [
	| aRiRepository anIceRepository |
	anIceRepository := IceRepository registry
		detect: [ :each | each name asLowercase beginsWith: aName asLowercase ].
	aRiRepository := RiRepository new
		iceRepository: anIceRepository;
		process;
		yourself.

	self new
		model: aRiRepository;
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

{ #category : #actions }
RiRepositoryPresenter >> actionLoadBranch: aRiBranchMark [
	aRiBranchMark local checkout.
	model process.
	self refreshOnModelUpdate.
]

{ #category : #actions }
RiRepositoryPresenter >> actionLoadCommit: aRiCommit [
	aRiCommit iceCommit checkout.
	model process.
	self refreshOnModelUpdate.
]

{ #category : #initialization }
RiRepositoryPresenter >> blockForElementSelected: aBlock [
	table whenSelectionChangedDo: [:selection |
		aBlock value: selection selectedItem ]
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := self selectedRiElement.

	selected marks select: #isBranchMark thenDo: [ :mark |
		menu addItem: [ :item | 
			item
				name: ('Checkout (in IMAGE) branch {1}' format: { mark shortname }); 
				action: [ self actionLoadBranch: mark ] ] ].

	selected isUncommited ifFalse: [
		menu addItem: [ :item | 
			item
				name: ('Checkout (in IMAGE) commit {1}' format: { selected shortId });
				action: [ self actionLoadCommit: selected ] ] ].

	menu addItem: [ :item | 
		item
			name: 'Inspect object';
			action: [ selected inspect ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> initializePresenters [

	table := self newTable.
	table
		showColumnHeaders;
		contextMenu: [ self contextMenuForTable ];
		addColumn: (SpImageTableColumn evaluated: [ :item | hiedraImageBuilder morphAt: item ]) beNotExpandable;
		addColumn: ((SpStringTableColumn title: 'Author' evaluated: #author) width: 120);
		addColumn: (SpImageTableColumn title: 'Comment' evaluated: [:item | commentImageBuilder morphAt: item ]);
		addColumn: ((SpStringTableColumn title: 'Date' evaluated: #date) width: 120).

	table whenBuiltDo: [ :ann |
		commentImageBuilder := RiCommentImageBuilder new.
		hiedraImageBuilder := RiHiedraImageBuilder new.
		hiedraImageBuilder tableMorph: ann widget.
		self refreshOnModelUpdate ].

]

{ #category : #initialization }
RiRepositoryPresenter >> refreshOnModelUpdate [
	self isBuilt ifTrue: [
		hiedraImageBuilder refreshWith: model elements.
		table items: model elements ]
]

{ #category : #accessing }
RiRepositoryPresenter >> selectedRiElement [
	^ table selection selectedItem
]
