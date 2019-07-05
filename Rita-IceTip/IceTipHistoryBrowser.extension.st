Extension { #name : #IceTipHistoryBrowser }

{ #category : #'*Rita-IceTip' }
IceTipHistoryBrowser >> initializeWidgets [
	super initializeWidgets.	
	commitList := self newIceTable.
	commitInfoTabs := self instantiate: RiIceTipCommitInfoPresenter.
	
	self initializeCommitList.
	
	commitList widget 
		onAnnouncement: FTSelectionChanged 
		send: #selectionChanged:
		to: self.
	
	self focusOrder 
		add: commitList;
		add: commitInfoTabs.
		
	self refresh
]

{ #category : #'*Rita-IceTip' }
IceTipHistoryBrowser class >> panelSpec [
	<spec>
	
	^ SpecPanedLayout newHorizontal
		add: #commitList;
		add: #commitInfoTabs;
		yourself
]
