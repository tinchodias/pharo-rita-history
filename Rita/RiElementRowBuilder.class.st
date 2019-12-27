"
I'm responsible of building the image (a Morph) to show in the comment column of RiRepositoryPresenter.

"
Class {
	#name : #RiElementRowBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraBuilder',
		'avatarDatabase'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiElementRowBuilder >> avatarsFor: item [
	
	| authorEmail committerEmail |
	authorEmail := item authorEmail.
	committerEmail := item committerEmail.
	
	^ Array streamContents: [ :stream |
		stream nextPut: (avatarDatabase avatarFor: authorEmail) asMorph.
		authorEmail ~= committerEmail ifTrue: [
			stream nextPut: (avatarDatabase avatarFor: committerEmail) asMorph
		] ]
]

{ #category : #visiting }
RiElementRowBuilder >> colorForAlreadyPushed [
	^ Color green
]

{ #category : #visiting }
RiElementRowBuilder >> colorForOnlyLocal [
	^ Color red
]

{ #category : #visiting }
RiElementRowBuilder >> iconForBranch [
	^ self iconNamed: #branch
]

{ #category : #visiting }
RiElementRowBuilder >> iconForTag [
	^ (self iconNamed: #breakpoint)
		flipBy: #horizontal
		centerAt: 0 @ 0
]

{ #category : #visiting }
RiElementRowBuilder >> iconForWorkingCopy [
	^ self iconNamed: #smallSave
]

{ #category : #accessing }
RiElementRowBuilder >> initialize [
	super initialize.
	
	hiedraBuilder := RiHiedraImageBuilder new.
]

{ #category : #accessing }
RiElementRowBuilder >> leftMorphsAt: item [
	^ 	{ hiedraBuilder morphAt: item. '   ' asMorph },
		(self avatarsFor: item),
		(self markMorphsAt: item),
		{ item comment asMorph hResizing: #spaceFill }

]

{ #category : #private }
RiElementRowBuilder >> markMorphText: text icon: icon color: color [
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
RiElementRowBuilder >> markMorphsAt: aRiElement [
	^ aRiElement marks collect: [ :each | each accept: self ]
]

{ #category : #accessing }
RiElementRowBuilder >> morphAt: item [
	| row |
	row := RiRowMorph new.
	(self leftMorphsAt: item) do: [ :each | row addItemLeft: each ].
	row addItemRight: ('  {1}       ' format: { item dateAndTime }) asMorph.
	^ row

]

{ #category : #accessing }
RiElementRowBuilder >> refreshWith: aRiRepositoryPresenter [
	hiedraBuilder refreshWith: aRiRepositoryPresenter.

	avatarDatabase := RiAvatarsDatabase new.
	avatarDatabase refreshWith: aRiRepositoryPresenter.
	

]

{ #category : #visiting }
RiElementRowBuilder >> visitBranchMark: aRiBranchMark [
	^ self
		markMorphText: aRiBranchMark shortname
		icon: self iconForBranch
		color:
			(aRiBranchMark isOnlyLocal
				ifTrue: [ self colorForOnlyLocal ]
				ifFalse: [ self colorForAlreadyPushed ])
]

{ #category : #visiting }
RiElementRowBuilder >> visitImageMark: aRiMark [
	^ self
		markMorphText: 'IMAGE'
		icon: self iconForWorkingCopy
		color: self colorForOnlyLocal
]

{ #category : #visiting }
RiElementRowBuilder >> visitTagMark: aRiTagMark [
	^ self
		markMorphText: aRiTagMark name
		icon: self iconForTag
		color: self colorForAlreadyPushed
]

{ #category : #visiting }
RiElementRowBuilder >> visitWorkdirMark: aRiMark [
	^ self
		markMorphText: 'WORKDIR'
		icon: self iconForWorkingCopy
		color: self colorForOnlyLocal
]
