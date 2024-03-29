"
I'm responsible of building the image (a Morph) to show in the comment column of RiRepositoryPresenter.

"
Class {
	#name : #RiElementRowBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraBuilder',
		'avatarDatabase',
		'repositoryPresenter'
	],
	#category : #'Rita-UI-Support'
}

{ #category : #'instance creation' }
RiElementRowBuilder class >> newForRepositoryPresenter: aRiRepositoryPresenter [
	^ self basicNew
		initializeForRepositoryPresenter: aRiRepositoryPresenter;
		yourself
]

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

{ #category : #'mark morph building' }
RiElementRowBuilder >> iconForBranch [
	^ self iconNamed: #branch
]

{ #category : #'mark morph building' }
RiElementRowBuilder >> iconForTag [
	^ (self iconNamed: #breakpoint)
		flipBy: #horizontal
		centerAt: 0 @ 0
]

{ #category : #'mark morph building' }
RiElementRowBuilder >> iconForWorkingCopy [
	^ self iconNamed: #smallSave
]

{ #category : #initialization }
RiElementRowBuilder >> initializeForRepositoryPresenter: aRiRepositoryPresenter [
	self initialize.

	hiedraBuilder := RiHiedraImageBuilder new.
	avatarDatabase := RiAvatarsDatabase new.
	repositoryPresenter := aRiRepositoryPresenter.
]

{ #category : #accessing }
RiElementRowBuilder >> leftMorphsAt: item [
	^ 	{ hiedraBuilder morphAt: item. '   ' asMorph },
		(self avatarsFor: item),
		(self pinMorphsFor: item),
		(self markMorphsAt: item),
		{ item comment asMorph
				color: (self textColorFor: item);
				hResizing: #spaceFill;
				yourself }
]

{ #category : #'mark morph building' }
RiElementRowBuilder >> localMarkMorphText: text icon: icon [
	^ (self markMorphText: text icon: icon)
		borderStyle: (DashedBorder new
			width: 1;
			dashColors: { self markMorphBorderColor. Color transparent }
				dashLengths: #(2 2);
			yourself);
		yourself
]

{ #category : #'mark morph building' }
RiElementRowBuilder >> markMorphBorderColor [
	self flag: #todo. "Fix... use aesthetics"
	^ self theme textColor alpha: 0.25
]

{ #category : #'mark morph building' }
RiElementRowBuilder >> markMorphText: text icon: icon [
	^ Morph new
		layoutInset: 2 @ 0;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (icon darker: 1) asMorph;
		addMorphBack: (' ' , text) asMorph;
		color: Color transparent;
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
	row addItemRight: (' [{1}]		{2}		     ' format: { item shortId. item dateAndTime }) asMorph.
	^ row

]

{ #category : #accessing }
RiElementRowBuilder >> pinMorphsFor: aRiElement [
	(repositoryPresenter isPinned: aRiElement)
		ifFalse: [ ^ #() ].
	^ {(self iconNamed: #breakpoint) asMorph}
]

{ #category : #accessing }
RiElementRowBuilder >> refresh [
	[ hiedraBuilder
		process: repositoryPresenter riRepository 
		rowHeight: repositoryPresenter rowHeightForHiedra ] future
			onSuccessDo: [ :_ | repositoryPresenter refreshOnAvatarsUpdate ];
			onFailureDo: [ :error | repositoryPresenter reportWarning: error ].

	[ avatarDatabase
		riRepository: repositoryPresenter riRepository;
		process ] future
			onSuccessDo: [ :_ | repositoryPresenter refreshOnAvatarsUpdate ];
			onFailureDo: [ :error | repositoryPresenter reportWarning: error ]

]

{ #category : #'mark morph building' }
RiElementRowBuilder >> remoteMarkMorphText: text icon: icon [
	^ (self markMorphText: text icon: icon)
		borderStyle: (SimpleBorder new
			width: 1;
			color: self markMorphBorderColor;
			yourself);
		yourself
]

{ #category : #accessing }
RiElementRowBuilder >> textColorFor: item [
	^ (repositoryPresenter hasSearchResults not or: [
		repositoryPresenter searchResultIncudes: item ])
			ifTrue: [ self theme textColor ]
			ifFalse: [ self theme disabledColor ]

]

{ #category : #accessing }
RiElementRowBuilder >> theme [
	^ Smalltalk ui theme
]

{ #category : #visiting }
RiElementRowBuilder >> visitBranchMark: aRiBranchMark [
	^ aRiBranchMark isOnlyLocal
		ifTrue: [
			self
				localMarkMorphText: aRiBranchMark shortname
				icon: self iconForBranch ]
		ifFalse: [
			self
				remoteMarkMorphText: aRiBranchMark shortname
				icon: self iconForBranch ]
]

{ #category : #visiting }
RiElementRowBuilder >> visitImageMark: aRiMark [
	^ self
		localMarkMorphText: 'IMAGE'
		icon: self iconForWorkingCopy
]

{ #category : #visiting }
RiElementRowBuilder >> visitTagMark: aRiTagMark [
	^ self
		remoteMarkMorphText: aRiTagMark name
		icon: self iconForTag
]

{ #category : #visiting }
RiElementRowBuilder >> visitWorkdirMark: aRiMark [
	^ self
		localMarkMorphText: 'WORKDIR'
		icon: self iconForWorkingCopy
]
