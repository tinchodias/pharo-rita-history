"
I represent a class read from an Iceberg repository, either from a commit or from the working directory in disk.

My contents is the class definition code.

See my superclasses for more information.
"
Class {
	#name : 'RiceClassDefinition',
	#superclass : 'RiceMethodContainerDefinition',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceClassDefinition >> accept: aVisitor [ 
	
	^ aVisitor visitClassDefinition: self
]

{ #category : 'patching' }
RiceClassDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [
	
	"Let the original MCClassDefinition intact, and give the responsability to modify it to the IceContainedDefinitions."
	
	"NOTE: MCPatcher is the other kind of visitor"
	
	(aMCPatcher isKindOf: MCPackageLoader) ifTrue: [ 
							aMCPatcher
		modifyDefinition: anotherIceDefinition asMCDefinition
		to: self asMCDefinition 
		
		]

]

{ #category : 'patching' }
RiceClassDefinition >> addToPatcher: aMCPatcher [ 
	
	aMCPatcher addDefinition: self asMCDefinition "copyWithoutVariables" "Variables will be added by IceVariableDefinitions"
]

{ #category : 'converting' }
RiceClassDefinition >> asMCDefinitionWithoutMetaSide [
	
	^ MCClassDefinition
		name: mcDefinition className
		superclassName: mcDefinition superclassName
		traitComposition: mcDefinition traitCompositionString
		classTraitComposition: mcDefinition classTraitCompositionString
		category: mcDefinition category
		instVarNames: mcDefinition instanceVariablesString
		classVarNames: mcDefinition classVariablesString
		poolDictionaryNames: mcDefinition poolDictionaries
		classInstVarNames: #()
		type: mcDefinition type
		comment: mcDefinition comment
		commentStamp: mcDefinition commentStamp
]

{ #category : 'accessing' }
RiceClassDefinition >> basicName [
	^ name
]

{ #category : 'accessing' }
RiceClassDefinition >> contents [
	mcDefinition ifNil: [ ^'' ].
	^ mcDefinition fullDefinitionString
]

{ #category : 'as yet unclassified' }
RiceClassDefinition >> icon [
	^ self iconNamed: #class
]

{ #category : 'testing' }
RiceClassDefinition >> isClassDefinition [
	
	^ true
]

{ #category : 'testing' }
RiceClassDefinition >> isLowImpactAppliedTo: anIceClassDefinition [ 
	^ mcDefinition isEqualIgnoringCommentTo: anIceClassDefinition mcDefinition 
]

{ #category : 'patching' }
RiceClassDefinition >> removeFromPatcher: aMCPatcher [ 
	
	aMCPatcher removeDefinition: self asMCDefinition 
]
