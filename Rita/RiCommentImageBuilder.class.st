"
I'm responsible of building the image (a Morph) to show in the comment column of RiRepositoryPresenter.

"
Class {
	#name : #RiCommentImageBuilder,
	#superclass : #Object,
	#instVars : [
		'presenter'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiCommentImageBuilder >> avatarsFor: item [
	
	| authorEmail committerEmail |
	authorEmail := item authorEmail.
	committerEmail := item committerEmail.
	
	^ Array streamContents: [ :stream |
		stream nextPut: (presenter avatarFor: authorEmail) asMorph.
		authorEmail ~= committerEmail ifTrue: [
			stream nextPut: (presenter avatarFor: committerEmail) asMorph
		] ]
]

{ #category : #visiting }
RiCommentImageBuilder >> colorForAlreadyPushed [
	^ Color green
]

{ #category : #visiting }
RiCommentImageBuilder >> colorForOnlyLocal [
	^ Color red
]

{ #category : #visiting }
RiCommentImageBuilder >> iconForBranch [
	^ self iconNamed: #branch
]

{ #category : #visiting }
RiCommentImageBuilder >> iconForTag [
	^ (self iconNamed: #breakpoint)
		flipBy: #horizontal
		centerAt: 0 @ 0
]

{ #category : #visiting }
RiCommentImageBuilder >> iconForWorkingCopy [
	^ self iconNamed: #smallSave
]

{ #category : #accessing }
RiCommentImageBuilder >> leftMorphsAt: item [
	^ { presenter hiedraAt: item. '   ' asMorph }, (self avatarsFor: item), (self markMorphsAt: item), {item comment asMorph hResizing: #spaceFill }
]

{ #category : #private }
RiCommentImageBuilder >> markMorphText: text icon: icon color: color [
	^ Morph new
		layoutInset: 2 @ 0;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (icon darker: 1) asMorph;
		addMorphBack: (' ' , text) asMorph;
		color: (color alpha: 0.3);
		yourself
]

{ #category : #accessing }
RiCommentImageBuilder >> markMorphsAt: aRiElement [
	^ aRiElement marks collect: [ :each | each accept: self ]
]

{ #category : #accessing }
RiCommentImageBuilder >> morphAt: item [
	| bar |
	bar := SpToolBarMorph new.
"	bar vResizing: #shrinkWrap."
	bar leftPanel vResizing: #shrinkWrap; cellInset: 5@0.
	bar rightPanel hResizing: #shrinkWrap.
	(self leftMorphsAt: item) do: [ :each | bar addItemLeft: each ].
	self flag: #todo. "Why?!?!?!?!"
	bar addItemRight: (item dateAndTime asString, '       ') asMorph.
	^ bar
]

{ #category : #accessing }
RiCommentImageBuilder >> presenter [
	^ presenter
]

{ #category : #accessing }
RiCommentImageBuilder >> presenter: anObject [
	presenter := anObject
]

{ #category : #visiting }
RiCommentImageBuilder >> visitBranchMark: aRiBranchMark [
	^ self
		markMorphText: aRiBranchMark shortname
		icon: self iconForBranch
		color:
			(aRiBranchMark isOnlyLocal
				ifTrue: [ self colorForOnlyLocal ]
				ifFalse: [ self colorForAlreadyPushed ])
]

{ #category : #visiting }
RiCommentImageBuilder >> visitImageMark: aRiMark [
	^ self
		markMorphText: 'IMAGE'
		icon: self iconForWorkingCopy
		color: self colorForOnlyLocal
]

{ #category : #visiting }
RiCommentImageBuilder >> visitTagMark: aRiTagMark [
	^ self
		markMorphText: aRiTagMark name
		icon: self iconForTag
		color: self colorForAlreadyPushed
]

{ #category : #visiting }
RiCommentImageBuilder >> visitWorkdirMark: aRiMark [
	^ self
		markMorphText: 'WORKDIR'
		icon: self iconForWorkingCopy
		color: self colorForOnlyLocal
]
