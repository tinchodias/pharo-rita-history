"
I am a Spec2 presenter for RiRepository objects.

"
Class {
	#name : #RiRepositoryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table',
		'commentImageBuilder',
		'hiedraImageBuilder',
		'blockForPinToCompareFrom',
		'avatarDatabase'
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
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : #actions }
RiRepositoryPresenter >> actionLoadCommit: aRiCommit [
	aRiCommit iceCommit checkout.
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : #accessing }
RiRepositoryPresenter >> avatarFor: emailString [
	self flag: #todo. "remove this"
	^ avatarDatabase avatarFor: emailString
]

{ #category : #initialization }
RiRepositoryPresenter >> blockForElementSelected: aBlock [
	table whenSelectionChangedDo: [:selection |
		aBlock value: selection selectedItem ]
]

{ #category : #initialization }
RiRepositoryPresenter >> blockForPinToCompareFrom: aBlock [
	blockForPinToCompareFrom := aBlock
]

{ #category : #initialization }
RiRepositoryPresenter >> columnForComment [

	^ SpImageTableColumn
		title: 'Description'
		evaluated: [ :item | commentImageBuilder morphAt: item ]
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := self selectedRiElement.

	menu addItem: [ :item | 
		item
			name: 'Pin to compare from';
			action: [ blockForPinToCompareFrom value: selected ] ].

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
			name: 'Refresh';
			action: [ self refreshOnModelUpdate ] ].

	menu addItem: [ :item | 
		item
			name: 'Inspect object';
			action: [ selected inspect ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> hiedraAt: item [
	^ hiedraImageBuilder morphAt: item
]

{ #category : #initialization }
RiRepositoryPresenter >> initializePresenters [

	commentImageBuilder := RiCommentImageBuilder new presenter: self; yourself.
	hiedraImageBuilder := RiHiedraImageBuilder new.

	table := self newTable.
	table
		hideColumnHeaders;
		contextMenu: [ self contextMenuForTable ];
		addColumn: self columnForComment.

	table whenBuiltDo: [ :ann |
		hiedraImageBuilder tableMorph: ann widget.
		self refreshOnModelUpdate ].

]

{ #category : #accessing }
RiRepositoryPresenter >> pinDiffModels [
	^ model at: #pinDiffModels
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnAvatarsUpdate [
	self defer: [table adapter widget refresh]
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnModelUpdate [
	self isBuilt ifFalse: [ ^ self ].

	avatarDatabase := RiAvatarsDatabase new.
	avatarDatabase refreshWith: self.

	hiedraImageBuilder refreshWith: self riRepository elements.
	table items: self riRepository elements
]

{ #category : #accessing }
RiRepositoryPresenter >> riRepository [
	^ model at: #repository
]

{ #category : #accessing }
RiRepositoryPresenter >> selectedRiElement [
	^ table selection selectedItem
]
