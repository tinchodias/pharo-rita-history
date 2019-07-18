Class {
	#name : #HiMImageDependenciesBuilder,
	#superclass : #Object,
	#instVars : [
		'packageNames',
		'navigator',
		'relationGraph',
		'nodeByDAPackage',
		'nodeByBehavior',
		'colorScale'
	],
	#category : #'Rita-Navigator-Model'
}

{ #category : #accessing }
HiMImageDependenciesBuilder >> build [
	self buildTopLevelNodes.
	self buildColorScale.
	
	navigator 
		topLevelNodes: self topLevelNodes;
		colorScale: self colorScale;
		build.

]

{ #category : #accessing }
HiMImageDependenciesBuilder >> buildColorScale [

	| tmpScale nodes |
	tmpScale := TSScale category20.
	nodes := self topLevelNodes asArray.
	
	colorScale := TSScale ordinal
		domain: nodes;
		range: (nodes collect: [:each | 
			| color |
			color := (packageNames includes: each object)
				ifTrue: [ navigator currentTheme textColor alpha: 0.8 ]
				ifFalse: [ (tmpScale scale: (each object readStream upTo: $-)) mixed: 0.75 with: navigator currentTheme backgroundColor ].
			color ]);
		yourself.

]

{ #category : #accessing }
HiMImageDependenciesBuilder >> buildTopLevelNodes [
	relationGraph := DAPackageRelationGraph onPackagesNamed: packageNames.
	relationGraph build.

	relationGraph packages do: [:aDAPackage |
		self ensureAddNodeForPackage: aDAPackage.

"		(relationGraph classesFor: aDAPackage) do: [ :aClass |
			aClass isMeta ifFalse: [
				self ensureAddNodeForClassNamed: aClass name in: aDAPackage] ].

		(relationGraph methodsFor: aDAPackage) do: [ :aMethod | 
			self ensureAddNodeForMethod: aMethod in: aDAPackage ].
"
		aDAPackage dependencies do: [:each | each accept: self ] ]

]

{ #category : #accessing }
HiMImageDependenciesBuilder >> colorScale [
	^ colorScale
]

{ #category : #private }
HiMImageDependenciesBuilder >> ensureAddNodeForClassNamed: aString in: aPackage [
	self assert: [ (aString endsWith: ' class') not ].

	^ nodeByBehavior
		at: aString
		ifAbsentPut: [ | node |
			node := HiMNode for: aString.
			(self ensureAddNodeForPackage: aPackage) addChild: node.
			node ]
]

{ #category : #private }
HiMImageDependenciesBuilder >> ensureAddNodeForMethod: aRGMethodDefinition in: aDAPackage [
	| classNode className |
	className := aRGMethodDefinition className.
	aRGMethodDefinition classIsMeta ifTrue: [ className := className allButLast: ' class' size ].
	
	classNode := self
		ensureAddNodeForClassNamed: className
		in: aDAPackage.

	^ classNode children
		detect: [ :each | each object = aRGMethodDefinition selector ]
		ifNone: [ | node |
			node := HiMNode for: aRGMethodDefinition selector.
			classNode addChild: node.
			node ]
]

{ #category : #private }
HiMImageDependenciesBuilder >> ensureAddNodeForPackage: aDAPackage [
	^ nodeByDAPackage
		at: aDAPackage
		ifAbsentPut: [ HiMNode for: aDAPackage packageName ]
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> initialize [
	super initialize.
	
	nodeByDAPackage := Dictionary new.
	nodeByBehavior := Dictionary new.
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> navigator [
	^ navigator
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> navigator: anObject [
	navigator := anObject
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> packageNames [
	^ packageNames
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> packageNames: anObject [
	packageNames := anObject
]

{ #category : #accessing }
HiMImageDependenciesBuilder >> topLevelNodes [
	^ nodeByDAPackage values
]

{ #category : #visiting }
HiMImageDependenciesBuilder >> visitDACompositeDependency: aDACompositeDependency [
	aDACompositeDependency dependencies do: [ :each | each accept: self ]
]

{ #category : #visiting }
HiMImageDependenciesBuilder >> visitDAExtensionDependency: aDAExtensionDependency [ 

	| from to |
	from := self ensureAddNodeForMethod: aDAExtensionDependency method in: aDAExtensionDependency source.
	to := self ensureAddNodeForClassNamed: aDAExtensionDependency theClass instanceSide name in: aDAExtensionDependency target.
	from addOutgoingLinkTo: to.
]

{ #category : #visiting }
HiMImageDependenciesBuilder >> visitDAInheritanceDependency: aDAInheritanceDependency [
	
	| from to |
	from := self ensureAddNodeForClassNamed: aDAInheritanceDependency theClass name in: aDAInheritanceDependency source.
	to := self ensureAddNodeForClassNamed: aDAInheritanceDependency superclass name in: aDAInheritanceDependency target.
	from addOutgoingLinkTo: to.
]

{ #category : #visiting }
HiMImageDependenciesBuilder >> visitDAMessageSendDependency: aDAMessageSendDependency [

	| from to |
	from := self ensureAddNodeForPackage: aDAMessageSendDependency source.
	to := self ensureAddNodeForPackage: aDAMessageSendDependency target.
	
	from addOutgoingLinkTo: to.
	
	self flag: #todo. "Not true!"
	"from withAllChildrenDo: [:node |
		node addOutgoingLinkTo: to ]."
]

{ #category : #visiting }
HiMImageDependenciesBuilder >> visitDAReferenceDependency: aDAReferenceDependency [ 

	| from to |
	from := self ensureAddNodeForMethod: aDAReferenceDependency method in: aDAReferenceDependency source.
	to := self ensureAddNodeForClassNamed: aDAReferenceDependency reference instanceSide name in: aDAReferenceDependency target.
	from addOutgoingLinkTo: to.
]
