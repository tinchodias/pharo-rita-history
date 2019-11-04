Class {
	#name : #RiRepositoriesPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
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
RiRepositoriesPresenter >> blockForOpenRepository: aBlock [
	table whenActivatedDo: [:selection |
		aBlock value: selection selectedItem ]
]

{ #category : #initialization }
RiRepositoriesPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := table selection selectedItem.

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
	table
		showColumnHeaders;
		contextMenu: [ self contextMenuForTable ];
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: #description).

	table whenBuiltDo: [ :ann |
		self refreshOnModelUpdate ].

]

{ #category : #accessing }
RiRepositoriesPresenter >> refreshOnModelUpdate [
	table items: model.
]
