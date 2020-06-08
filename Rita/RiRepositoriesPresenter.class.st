Class {
	#name : #RiRepositoriesPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table',
		'blockForOpenPullRequests',
		'blockForOpenRepository'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiRepositoriesPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
"		add: #menuBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #table;
		yourself
]

{ #category : #examples }
RiRepositoriesPresenter class >> newWithRegistry [
	^ self new
		model: IceRepository registry;
		yourself
]

{ #category : #examples }
RiRepositoriesPresenter class >> open [
	<example>

	self newWithRegistry
		openWithSpec;
		withWindowDo: [ :window | 
			window
				extent: 500 @ 800;
				title: 'Repositories' ]
]

{ #category : #accessing }
RiRepositoriesPresenter >> blockForOpenPullRequests: aBlock [
	blockForOpenPullRequests:= aBlock
]

{ #category : #accessing }
RiRepositoriesPresenter >> blockForOpenRepository: aBlock [
	blockForOpenRepository := aBlock
]

{ #category : #initialization }
RiRepositoriesPresenter >> contextMenuForTable [
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
			name: 'Inspect object';
			action: [ selected inspect ] ].
	menu addItem: [ :item | 
		item
			name: 'Refresh';
			action: [ self refreshOnModelUpdate ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoriesPresenter >> initializePresenters [

	table := self newTable.

	"Set up columns"
	table
		showColumnHeaders;
		addColumn: ((SpImageTableColumn evaluated: [ :each | self iconNamed: #git ]) width: 20);
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
RiRepositoriesPresenter >> refreshOnModelUpdate [
	table items: model.
]
