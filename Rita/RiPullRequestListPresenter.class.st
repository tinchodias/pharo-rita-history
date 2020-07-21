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
			name: 'View Diff to Repository Head';
			action: [ self openDiffFor: selected ] ].
	menu addItem: [ :item |
		item
			name: 'Open in Web Browser';
			action: [ self openInWebBrowser: selected ] ].
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