Class {
	#name : #ZuMethodDiffTool,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'diffMorph',
		'model',
		'diffPresenter',
		'selectedMethod'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #activation }
ZuMethodDiffTool class >> browserTabActivation [
	"This declaration specifies that in any browser when methods are selected, a diff tool will be available in a tab."

	<classAnnotation>
	^ ClyTabActivationStrategy for: ClyMethod asCalypsoItemContext
]

{ #category : #accessing }
ZuMethodDiffTool class >> shouldBeActivatedInContext: aBrowserContext [
	^ aBrowserContext lastSelectedItem hasProperty: ZuChangeProperty
]

{ #category : #accessing }
ZuMethodDiffTool class >> tabOrder [
	^ 100
]

{ #category : #accessing }
ZuMethodDiffTool >> activationPriority [
	^ model isNil
		ifTrue: [ 0 ]
		ifFalse: [ self tabOrder ]
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToCurrentBrowserContext [

	^ browser methodSelection isEmpty
		  ifTrue: [ browser isClassSelected: selectedMethod origin ]
		  ifFalse: [ browser isMethodSelected: selectedMethod ]
]

{ #category : #testing }
ZuMethodDiffTool >> belongsToRemovedBrowserContext [

	super belongsToRemovedBrowserContext ifTrue: [ ^ true ].

	selectedMethod := selectedMethod origin
		                localMethodNamed: selectedMethod selector
		                ifAbsent: [ ^ true ].
	^ false
]

{ #category : #building }
ZuMethodDiffTool >> build [

	diffPresenter := RiPRSingleDiffPresenter new.
	diffMorph := diffPresenter buildWithSpec.

	diffPresenter
		model: model;
		selectIceNode: (model at: #selectedIceNode);
		yourself.
	
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

{ #category : #testing }
ZuMethodDiffTool >> isSimilarTo: anotherBrowserTool [

	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^false ].
	
	^ selectedMethod == anotherBrowserTool selectedMethod or: 
		[ selectedMethod selector == anotherBrowserTool selectedMethod selector
			and: [ selectedMethod origin == anotherBrowserTool selectedMethod origin ] ]
]

{ #category : #printing }
ZuMethodDiffTool >> printContext [
	^ selectedMethod printSystemPath
]

{ #category : #initialization }
ZuMethodDiffTool >> resetStateForSnapshot [
	super resetStateForSnapshot.
	
	diffPresenter := diffMorph := nil.
	"Needed?"
]

{ #category : #testing }
ZuMethodDiffTool >> selectedMethod [
	^ selectedMethod
]

{ #category : #initialization }
ZuMethodDiffTool >> setUpModelFromContext [

	| aPlugin |
	aPlugin := context tool navigationEnvironment getPlugin: ZuEnvironmentPlugin.
	
	selectedMethod := context lastSelectedMethod.
	model := aPlugin
		toolModelFor: selectedMethod
		ifPresent: [ :m | m ]
		ifAbsent: [ nil ]

]
