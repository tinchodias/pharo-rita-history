"
I represent a method read from an Iceberg repository, either from a commit or from the working directory in disk.

My contents is the code of the method.

See my superclasses for more information.
"
Class {
	#name : 'RiceMethodDefinition',
	#superclass : 'RiceCodeDefinition',
	#instVars : [
		'className',
		'classIsMeta',
		'protocol',
		'sourceCode'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceMethodDefinition class >> className: aClassName classIsMeta: classIsMeta protocol: protocol name: aString sourceCode: source [

	^ (self named: aString)
		className: aClassName;
		classIsMeta: classIsMeta;
		protocol: protocol;
		sourceCode: source;
		yourself
]

{ #category : 'comparing' }
RiceMethodDefinition >> = anotherDefinition [
	"A method can be equal and belong to another class (and be in the other side). 
	 And yes, even if this usually should not happen, it happens (and not always is incorrect)"
	^ super = anotherDefinition 
		and: [ self className = anotherDefinition className 
		and: [ self classIsMeta = anotherDefinition classIsMeta ] ]
]

{ #category : 'visiting' }
RiceMethodDefinition >> accept: aVisitor [
	
	^ aVisitor visitMethodNode: self
]

{ #category : 'morphic-compatibility' }
RiceMethodDefinition >> actualClass [

	^ self contextClass
]

{ #category : 'patching' }
RiceMethodDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [
	aMCPatcher
		modifyDefinition: anotherIceDefinition asMCDefinition
		to: self asMCDefinition
]

{ #category : 'patching' }
RiceMethodDefinition >> addToPatcher: aMCPatcher [ 
	
	aMCPatcher addDefinition: self asMCDefinition
]

{ #category : 'patching' }
RiceMethodDefinition >> asMCDefinition [

	^ MCMethodDefinition 
		className: self className
		classIsMeta: self classIsMeta
		selector: self name
		category: self protocol
		timeStamp: ''
		source: sourceCode
]

{ #category : 'accessing' }
RiceMethodDefinition >> ast [

	^ RBParser parseMethod: sourceCode
]

{ #category : 'as yet unclassified' }
RiceMethodDefinition >> browse [
	
	| owner |
	owner := Smalltalk globals at: self className.
	self classIsMeta ifTrue: [ owner := owner classSide ].
	(owner >> name) browse
]

{ #category : 'as yet unclassified' }
RiceMethodDefinition >> canBeBrowsed [
	
	^ Smalltalk globals at: className
		ifPresent: [ :class | class includesSelector: name ]
		ifAbsent: [ false ]
]

{ #category : 'as yet unclassified' }
RiceMethodDefinition >> canBrowseReferences [
	
	^ false
]

{ #category : 'accessing' }
RiceMethodDefinition >> classIsMeta [
	^ classIsMeta
]

{ #category : 'accessing' }
RiceMethodDefinition >> classIsMeta: anObject [
	classIsMeta := anObject
]

{ #category : 'accessing' }
RiceMethodDefinition >> className [

	^ className
]

{ #category : 'accessing' }
RiceMethodDefinition >> className: anObject [
	className := anObject
]

{ #category : 'accessing' }
RiceMethodDefinition >> contents [

	^ '"', self protocol, '"
', sourceCode
]

{ #category : 'morphic-compatibility' }
RiceMethodDefinition >> contextClass [
	
	| class |
	class := Smalltalk globals at: self className ifAbsent: [ ^ nil ].
	self classIsMeta ifTrue: [ class := class classSide ].
	^ class
]

{ #category : 'as yet unclassified' }
RiceMethodDefinition >> icon [
	
	^ self iconNamed: #changeUpdate
]

{ #category : 'actions' }
RiceMethodDefinition >> install [
	
	self asMCDefinition load
]

{ #category : 'morphic-compatibility' }
RiceMethodDefinition >> isLoadable [
	^ self contextClass notNil
]

{ #category : 'testing' }
RiceMethodDefinition >> isLowImpactAppliedTo: anotherIceMethodDefinition [
	^ sourceCode = anotherIceMethodDefinition sourceCode
		or: [ self ast = anotherIceMethodDefinition ast ]
]

{ #category : 'testing' }
RiceMethodDefinition >> isMethodDefinition [
	
	^ true
]

{ #category : 'accessing' }
RiceMethodDefinition >> key [
	^ self classIsMeta
		ifTrue: [ 'Method (class): ', name ]
		ifFalse: [ 'Method (inst): ', name ]
]

{ #category : 'accessing' }
RiceMethodDefinition >> ownerName [
	
	^ className
]

{ #category : 'accessing' }
RiceMethodDefinition >> protocol [
	^ protocol
]

{ #category : 'accessing' }
RiceMethodDefinition >> protocol: anObject [
	protocol := anObject
]

{ #category : 'patching' }
RiceMethodDefinition >> removeFrom: aPatcher [
	
	aPatcher removeMethod: self
]

{ #category : 'patching' }
RiceMethodDefinition >> removeFromPatcher: aMCPatcher [ 
	
	aMCPatcher removeDefinition: self asMCDefinition
]

{ #category : 'accessing' }
RiceMethodDefinition >> selector [
	
	^ name
]

{ #category : 'accessing' }
RiceMethodDefinition >> sourceCode [

	^ sourceCode
]

{ #category : 'accessing' }
RiceMethodDefinition >> sourceCode: aString [

	sourceCode := aString
]
