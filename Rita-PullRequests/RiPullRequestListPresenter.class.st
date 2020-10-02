Class {
	#name : #RiPullRequestListPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'listPresenter',
		'blockForPRSelected',
		'rowBuilder'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPullRequestListPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #listPresenter;
		yourself
]

{ #category : #actions }
RiPullRequestListPresenter >> actionCheckoutPR: anIceGitHubPullRequest [ 
	anIceGitHubPullRequest branch checkout
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

"	menu addItem: [ :item |
		item
			name: 'View Diff to Base';
			icon: (self iconNamed: #diff);
			action: [ self openDiffToBaseOf: selected ] ].
	menu addItem: [ :item |
		item
			name: 'View Diff to Repository HEAD';
			icon: (self iconNamed: #diff);
			action: [ self openDiffToHeadOf: selected ] ]."

	menu addItem: [ :item |
		item
			name: 'Checkout (in IMAGE)';
			icon: (self iconNamed: #smallSystemBrowser);
			action: [ self actionCheckoutPR: selected ] ].

	menu addItem: [ :item |
		item
			name: 'Open diff in System Browser';
			icon: (self iconNamed: #smallSystemBrowser);
			action: [ self openBrowserWithDiff: selected ] ].
	
	menu addItem: [ :item |
		item
			name: 'Open branch tip in System Browser';
			icon: (self iconNamed: #smallSystemBrowser);
			action: [ RiCommitBrowseUtility browse: selected basicHeadCommit ] ].

	menu addItem: [ :item |
		item
			name: 'Open in Web Browser';
			icon: (self iconNamed: #remote);
			action: [ self openInWebBrowser: selected ] ].
	menu addItem: [ :item | 
		item
			name: 'Reload';
			icon: (self iconNamed: #smallUpdate);
			action: [ (model at: #blockToRefreshPullRequests) value ] ].
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

{ #category : #actions }
RiPullRequestListPresenter >> openBrowserWithDiff: anIceGitHubPullRequest [ 

	| env detailModel aPlugin |
	self flag: #todo. "FIX HACK"
	detailModel := (self owner instVarNamed: 'detailPresenter') model.

	env := RiCommitBrowseUtility ringEnvironmentFor: (detailModel at: #pullRequestDiff) sourceVersion.
	
	aPlugin := ZuEnvironmentPlugin new
		pullRequestModel: detailModel;
		yourself.
	
	env
		zurichBrowseAs: 'Changes'
		extraEnvironmentPlugin: aPlugin.

]

{ #category : #initialization }
RiPullRequestListPresenter >> openDiffToBaseOf: aPR [ 
	| iceDiff |
	iceDiff := aPR diffToBase.
	(model at: #blockForSpawn) value: (model copy
		at: #iceDiff put: iceDiff;
		add: #shadowedIceNodes -> IdentitySet new;
		add: #expandedIceNodes -> OrderedCollection new;
		yourself)
]

{ #category : #initialization }
RiPullRequestListPresenter >> openDiffToHeadOf: aPR [ 
	| iceDiff | 
	iceDiff := aPR diffToRepositoryHead.
	(model at: #blockForSpawn) value: (model copy
		at: #iceDiff put: iceDiff;
		add: #shadowedIceNodes -> IdentitySet new;
		add: #expandedIceNodes -> OrderedCollection new;
		yourself)
]

{ #category : #initialization }
RiPullRequestListPresenter >> openInWebBrowser: aPR [ 
	WebBrowser openOn: aPR htmlUrl
]

{ #category : #accessing }
RiPullRequestListPresenter >> refreshOnModelUpdate [
	listPresenter items: (model at: #pullRequestsToShow)
]
