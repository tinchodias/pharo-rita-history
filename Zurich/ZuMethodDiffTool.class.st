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
	"This declaration specifies that in any browser when methods are selected, a diff tool will be available in a tab."

	<classAnnotation>
	^ ClyTabActivationStrategy for: ClyMethod asCalypsoItemContext
]

{ #category : #accessing }
ZuMethodDiffTool class >> shouldBeActivatedInContext: aBrowserContext [
	^ aBrowserContext lastSelectedItem hasProperty: ZuChangedTag
]

{ #category : #accessing }
ZuMethodDiffTool class >> tabOrder [
	^ 100000
]

{ #category : #accessing }
ZuMethodDiffTool >> activationPriority [
	^ leftMethod = rightMethod ifTrue: [ 0 ] ifFalse: [ ClyClassDefinitionEditorToolMorph tabOrder + 1  ]
]

{ #category : #controlling }
ZuMethodDiffTool >> attachToSystem [

	browser system 
		when: (ClyMethodChange ofAll: {self leftMethod. self rightMethod}) 
		send: #triggerUpdate to: self
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToCurrentBrowserContext [
	^(browser isMethodSelected: leftMethod) 
		and: [ browser isMethodSelected: rightMethod ]
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToRemovedBrowserContext [
	^ false
]

{ #category : #building }
ZuMethodDiffTool >> build [
	| tmp2 |
	diffMorph := DiffMorph
		from: self leftMethod
		to: self rightMethod.
	tmp2 := diffMorph.
	tmp2
		contextClass: self rightMethod;
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
ZuMethodDiffTool >> isSimilarTo: anotherBrowserTool [
	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^false ].
	
	^{leftMethod. rightMethod} asIdentitySet = {anotherBrowserTool leftMethod. anotherBrowserTool rightMethod  } asIdentitySet
]

{ #category : #accessing }
ZuMethodDiffTool >> leftMethod [
	^leftMethod
]

{ #category : #printing }
ZuMethodDiffTool >> printContext [
	^'left / ', leftMethod printSystemPath , ' vs right / ', rightMethod printSystemPath
]

{ #category : #initialization }
ZuMethodDiffTool >> resetStateForSnapshot [
	super resetStateForSnapshot.
	
	diffMorph := nil
]

{ #category : #accessing }
ZuMethodDiffTool >> rightMethod [
	^rightMethod
]

{ #category : #initialization }
ZuMethodDiffTool >> setUpModelFromContext [

	| tmp1 arg1|
	arg1 := context lastSelectedMethod.
	tmp1 := LastZuEnvironmentPlugin.
	tmp1 iceDiff tree allChildrenDo: [ :each |
		| def |
		def := each value definition.
		(def isMethodDefinition and: [ 
		def selector = arg1 selector and: [ 
		def className = arg1 origin name ] ]) ifTrue: [
			leftMethod := each value rightContents.
			rightMethod := each value leftContents .
			^ self ] ].

	leftMethod := context lastSelectedMethod sourceCode.
	rightMethod := context lastSelectedMethod sourceCode
]

{ #category : #updating }
ZuMethodDiffTool >> update [
	leftMethod := leftMethod origin 
		localMethodNamed: leftMethod selector ifAbsent: [^self].
	rightMethod := rightMethod origin 
		localMethodNamed: rightMethod selector ifAbsent: [^self].
	
	super update.
	
	diffMorph from: leftMethod sourceCode to: rightMethod sourceCode
]
