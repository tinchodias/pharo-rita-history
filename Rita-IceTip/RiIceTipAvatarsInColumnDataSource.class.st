"
I'm a FastTable data source that demonstrates how to show avatars in the author column of Iceberg repositories view.

Activate with:

	self beCurrentDataSourceClass.
	
And open the Iceberg repository view.
"
Class {
	#name : #RiIceTipAvatarsInColumnDataSource,
	#superclass : #RiIceTipAvatarsDataSource,
	#category : #'Rita-IceTip-HiedraCommits'
}

{ #category : #accessing }
RiIceTipAvatarsInColumnDataSource >> avatarSize [
	^ 16
]

{ #category : #accessing }
RiIceTipAvatarsInColumnDataSource >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view. I will probably return a FTCellMorph."
	
	| cell |	
	cell := super cellColumn: column row: rowIndex.
	
	column id = 'Author' ifTrue: [
		cell addMorphFront: ((self avatarFor: (self elementAt: rowIndex) id) asMorph
			useRoundedCorners;
			yourself)
	].

	
	^ cell
]
