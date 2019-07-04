Class {
	#name : #RiCommentImageBuilder,
	#superclass : #Object,
	#category : #'Rita-UI'
}

{ #category : #examples }
RiCommentImageBuilder class >> defaultSpec [
	^ SpBoxLayout newVertical
"		add: #menuBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #table;
		yourself
]

{ #category : #examples }
RiCommentImageBuilder class >> openOnRepositoryNamed: aName [
	| aRiRepository anIceRepository |
	anIceRepository := IceRepository registry
		detect: [ :each | each name beginsWith: aName ].
	aRiRepository := RiRepository new
		iceRepository: anIceRepository;
		process;
		yourself.
	^ (self on: aRiRepository) openWithSpec
]

{ #category : #examples }
RiCommentImageBuilder class >> voyageExample [
	<example>

	^ self openOnRepositoryNamed: 'voyage'
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
	^ Smalltalk ui iconNamed: #branch
]

{ #category : #visiting }
RiCommentImageBuilder >> iconForTag [
	^ (self iconNamed: #breakpoint)
		flipBy: #horizontal
		centerAt: 0 @ 0
]

{ #category : #visiting }
RiCommentImageBuilder >> iconForWorkingCopy [
	^ Smalltalk ui iconNamed: #smallSave
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
	^ FTCellMorph new
		cellInset: 5;
		addAllMorphs: (self markMorphsAt: item);
		addMorphBack: item comment asMorph;
		yourself
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
		color:
			(aRiMark element isUncommited
				ifTrue: [ self colorForOnlyLocal ]
				ifFalse: [ self colorForAlreadyPushed ])
]

{ #category : #visiting }
RiCommentImageBuilder >> visitTagMark: aRiTagMark [
	^ self
		markMorphText: aRiTagMark name
		icon: self iconForTag
		color: self colorForAlreadyPushed
]
