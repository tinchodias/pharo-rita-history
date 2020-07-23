Class {
	#name : #RiPullRequestListPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'listPresenter',
		'blockForPRSelected',
		'rowBuilder'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPullRequestListPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #listPresenter;
		yourself
]

{ #category : #accessing }
RiPullRequestListPresenter >> blockForPRSelected: aBlockClosure [
	blockForPRSelected := aBlockClosure
]

{ #category : #initialization }
RiPullRequestListPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := listPresenter selection selectedItem.

	menu addItem: [ :item |
		item
			name: 'View Diff to Repository HEAD';
			icon: (self iconNamed: #diff);
			action: [ self openDiffFor: selected ] ].
	menu addItem: [ :item |
		item
			name: 'Open in Web Browser';
			icon: (self iconNamed: #remote);
			action: [ self openInWebBrowser: selected ] ].
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
RiPullRequestListPresenter >> initializePresenters [

	rowBuilder := RiPullRequestRowBuilder new.

	listPresenter := self newTable.
	listPresenter
		hideColumnHeaders;
		addColumn: (SpImageTableColumn
			evaluated: [ :item | rowBuilder morphAt: item ]);
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: blockForPRSelected ];
		contextMenu: [ self contextMenuForTable ].

]

{ #category : #initialization }
RiPullRequestListPresenter >> openDiffFor: aPR [ 
	| iceDiff |
	iceDiff := aPR diffToRepositoryHead.
	(model at: #blockForSpawn) value: iceDiff
]

{ #category : #initialization }
RiPullRequestListPresenter >> openInWebBrowser: aPR [ 
	WebBrowser openOn: aPR htmlUrl
]

{ #category : #accessing }
RiPullRequestListPresenter >> refreshOnModelUpdate [
	listPresenter items: model

]
