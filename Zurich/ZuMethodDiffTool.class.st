Class {
	#name : #ZuMethodDiffTool,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'diffMorph',
		'leftMethod',
		'rightMethod'
	],
	#category : #Zurich
}

{ #category : #activation }
ZuMethodDiffTool class >> browserTabActivation [
	<classAnnotation>
	^ ClyTabActivationStrategy for: ClyMethod asCalypsoItemContext
]

{ #category : #accessing }
ZuMethodDiffTool class >> shouldBeActivatedInContext: arg1 [
	^ arg1 lastSelectedItem hasProperty: ZuChangedTag
]

{ #category : #accessing }
ZuMethodDiffTool class >> tabOrder [
	^ 100000
]

{ #category : #accessing }
ZuMethodDiffTool >> activationPriority [
	^ 0
]

{ #category : #controlling }
ZuMethodDiffTool >> attachToSystem [
	browser system
		when:
			(ClyMethodChange
				ofAll:
					{self leftMethod.
					self rightMethod})
		send: #triggerUpdate
		to: self
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToCurrentBrowserContext [
	^ (browser isMethodSelected: leftMethod)
		and: [ browser isMethodSelected: rightMethod ]
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToRemovedBrowserContext [
	^ self leftMethod isInstalled not
		or: [ self rightMethod isInstalled not ]
]

{ #category : #building }
ZuMethodDiffTool >> build [
	| tmp2 |
	diffMorph := DiffMorph
		from: self leftMethod sourceCode
		to: self rightMethod sourceCode.
	tmp2 := diffMorph.
	tmp2
		contextClass: self rightMethod sourceCode;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		showOptions: false.
	self addMorph: diffMorph fullFrame: LayoutFrame identity
]

{ #category : #initialization }
ZuMethodDiffTool >> defaultIconName [
	^ ZuTheme current changeIconSelector
]

{ #category : #initialization }
ZuMethodDiffTool >> defaultTitle [
	^ 'Diff'
]

{ #category : #controlling }
ZuMethodDiffTool >> detachFromSystem [
	browser system unsubscribe: self
]

{ #category : #testing }
ZuMethodDiffTool >> isSimilarTo: arg1 [
	(super isSimilarTo: arg1)
		ifFalse: [ ^ false ].
	^ {leftMethod.
	rightMethod} asIdentitySet
		=
			{arg1 leftMethod.
			arg1 rightMethod} asIdentitySet
]

{ #category : #accessing }
ZuMethodDiffTool >> leftMethod [
	^ leftMethod
]

{ #category : #printing }
ZuMethodDiffTool >> printContext [
	^ 'left / ' , leftMethod printSystemPath , ' vs right / '
		, rightMethod printSystemPath
]

{ #category : #initialization }
ZuMethodDiffTool >> resetStateForSnapshot [
	super resetStateForSnapshot.
	diffMorph := nil
]

{ #category : #accessing }
ZuMethodDiffTool >> rightMethod [
	^ rightMethod
]

{ #category : #initialization }
ZuMethodDiffTool >> setUpModelFromContext [
	leftMethod := context firstSelectedMethod.
	rightMethod := context lastSelectedMethod
]

{ #category : #updating }
ZuMethodDiffTool >> update [
	leftMethod := leftMethod origin
		localMethodNamed: leftMethod selector
		ifAbsent: [ ^ self ].
	rightMethod := rightMethod origin
		localMethodNamed: rightMethod selector
		ifAbsent: [ ^ self ].
	super update.
	diffMorph from: leftMethod sourceCode to: rightMethod sourceCode
]
