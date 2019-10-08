Class {
	#name : #RiIceDiffEntityCollector,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'nodesWithClasses',
		'nodesWithMethods',
		'nodesWithClassExtensions',
		'nodesWithMetaclasses',
		'nodesWithPackages',
		'nodesWithFiles'
	],
	#category : #'Rita-Torch-Utilities'
}

{ #category : #initialization }
RiIceDiffEntityCollector >> initialize [
	super initialize.
	
	nodesWithPackages := OrderedCollection new.
	nodesWithClasses := OrderedCollection new.
	nodesWithMetaclasses := OrderedCollection new.
	nodesWithMethods := OrderedCollection new.
	nodesWithClassExtensions := OrderedCollection new.
	nodesWithFiles := OrderedCollection new.
]

{ #category : #accessing }
RiIceDiffEntityCollector >> nodesWithClassExtensions [
	^ nodesWithClassExtensions
]

{ #category : #accessing }
RiIceDiffEntityCollector >> nodesWithClasses [
	^ nodesWithClasses
]

{ #category : #accessing }
RiIceDiffEntityCollector >> nodesWithMetaclasses [
	^ nodesWithMetaclasses
]

{ #category : #accessing }
RiIceDiffEntityCollector >> nodesWithMethods [
	^ nodesWithMethods
]

{ #category : #accessing }
RiIceDiffEntityCollector >> nodesWithPackages [
	^ nodesWithPackages
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitAddition: anIceAddition [ 
	self visitRemoval: anIceAddition
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitClassDefinition: anIceClassDefinition [ 
	anIceClassDefinition isMeta
		ifFalse: [ nodesWithClasses add: currentNode ]
		ifTrue: [ nodesWithMetaclasses add: currentNode ].
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitDirectoryDefinition: anIceDirectoryDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitExtensionDefinition: anIceExtensionDefinition [ 
	nodesWithClassExtensions add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitFileNode: anIceFileDefinition [ 
	nodesWithFiles add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitMethodNode: anIceMethodDefinition [ 
	nodesWithMethods add: currentNode.
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitModification: anIceModification [ 
	
	^ anIceModification leftDefinition accept: self
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitNoModification: anIceNoModification [ 

	anIceNoModification definition accept: self
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitPackage: anIcePackageDefinition [ 
	nodesWithPackages add: currentNode.
	self visitChildrenOf: currentNode.
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitRemoval: anIceRemoval [ 
	anIceRemoval definition accept: self
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitRootDefinition: anIceRootDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiIceDiffEntityCollector >> visitTraitDefinition: anIceTraitDefinition [ 
	self visitClassDefinition: anIceTraitDefinition
]
