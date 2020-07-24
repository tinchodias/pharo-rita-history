Class {
	#name : #RiRepositoryListPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table',
		'blockForOpenPullRequests',
		'blockForOpenRepository'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiRepositoryListPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
"		add: #menuBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #table;
		yourself
]

{ #category : #accessing }
RiRepositoryListPresenter >> blockForOpenPullRequests: aBlock [
	blockForOpenPullRequests:= aBlock
]

{ #category : #accessing }
RiRepositoryListPresenter >> blockForOpenRepository: aBlock [
	blockForOpenRepository := aBlock
]

{ #category : #initialization }
RiRepositoryListPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := table selection selectedItem.

	menu addItem: [ :item |
		item
			name: 'Open Repository';
			action: [ blockForOpenRepository value: selected ] ].
	menu addItem: [ :item |
		item
			name: 'View Pull Requests';
			action: [ blockForOpenPullRequests value: selected ] ].
	menu addItem: [ :item |
		item
			name: 'Open folder';
			action: [ selected openInNativeBrowser ] ].
	menu addItem: [ :item |
		item
			name: 'Browse code in HEAD';
			action: [ RiCommitBrowseUtility browse: selected iceRepository headCommit ] ].
	menu addItem: [ :item | 
		item
			name: 'Refresh list';
			icon: (self iconNamed: #smallUpdate);
			action: [ self refreshOnModelUpdate ] ].
	menu addItem: [ :item | 
		item
			name: 'Inspect object';
			icon: (self iconNamed: #smallInspectIt);
			action: [ selected inspect ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryListPresenter >> initializePresenters [

	table := self newTable.

	"Set up columns"
	table
		addColumn: ((SpImageTableColumn title: '' evaluated: [ :each | self iconNamed: #git ]) width: 20);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: #description).

	"Set up actions"
	table
		contextMenu: [ self contextMenuForTable ];
		whenActivatedDo: [:selection |
			blockForOpenRepository value: selection selectedItem ].
	
	table whenBuiltDo: [ :ann |
		self refreshOnModelUpdate ].

]

{ #category : #accessing }
RiRepositoryListPresenter >> refreshOnModelUpdate [
	table items: model.
]
