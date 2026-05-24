Class {
	#name : 'RiRepositoryListPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'table',
		'blockForOpenPullRequests'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'commands' }
RiRepositoryListPresenter >> actionFetch [

	table selection selectedItem
		fetch;
		refresh.
	self flag: #todo. "should update the model, which should announce changed and trigger the next send..."
	self refreshOnModelUpdate
]

{ #category : 'accessing' }
RiRepositoryListPresenter >> blockForOpenPullRequests: aBlock [
	blockForOpenPullRequests:= aBlock
]

{ #category : 'initialization' }
RiRepositoryListPresenter >> contextMenuForPullRequestsFor: aRiRepository [
	| menu |
	menu := self newMenu.
	aRiRepository iceRepository remotes
		select: [ :each | each host = 'github.com' ]
		thenDo: [ :each | 
			menu
				addItem: [ :item | 
					item
						name: each name;
						action: [ blockForOpenPullRequests value: each ] ] ].
	^ menu
]

{ #category : 'initialization' }
RiRepositoryListPresenter >> contextMenuForTable [

	| menu selected |
	menu := self newMenu.

	selected := table selection selectedItem.

	menu addItem: [ :item |
			item
				name: 'Open Repository';
				action: [ table doActivateAtIndex: table selection selectedIndex ] ].
	menu addItem: [ :item |
			item
				name: 'View Pull Requests';
				subMenu: (self contextMenuForPullRequestsFor: selected) ].
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
				name: 'Fetch';
				icon: (self iconNamed: #smallUpdate);
				action: [ self actionFetch ] ].
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

{ #category : 'layout' }
RiRepositoryListPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: table;
		  yourself
]

{ #category : 'initialization' }
RiRepositoryListPresenter >> initializePresenters [

	table := self newTable.

	"Set up columns"
	table
		addColumn: ((SpImageTableColumn title: '' evaluated: [ :each | self iconNamed: #git ]) width: 20);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: #description).

	"Set up actions"
	table contextMenu: [ self contextMenuForTable ].
	
	table whenBuiltDo: [ :ann |
		self refreshOnModelUpdate ].

]

{ #category : 'testing' }
RiRepositoryListPresenter >> isForRepository: aRiRepository [
	"I am the home page. Not a page specific for a repository"

	^ false
]

{ #category : 'updating' }
RiRepositoryListPresenter >> refreshOnModelUpdate [

	table items: model
]

{ #category : 'enumerating' }
RiRepositoryListPresenter >> whenOpeningRepositoryDo: aBlock [

	table whenActivatedDo: [ :selection | aBlock value: selection selectedItem ]
]
