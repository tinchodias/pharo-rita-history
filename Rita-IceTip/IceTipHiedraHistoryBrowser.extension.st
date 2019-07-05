Extension { #name : #IceTipHiedraHistoryBrowser }

{ #category : #'*Rita-IceTip' }
IceTipHiedraHistoryBrowser >> initializeCommitList [

	"Add the Hiedra column at the beginning. The Datasource has the logic to render it."
	commitList widget addColumn:
		(IceTipTableColumn new
			id: ' ';
			yourself).

	super initializeCommitList.
]

{ #category : #'*Rita-IceTip' }
IceTipHiedraHistoryBrowser >> newCommitsDataSource [
	^ RiIceTipDataSource newCurrentDataSource
		tool: self;
		elements: #(); "It will be set when refreshing"
		yourself
]
