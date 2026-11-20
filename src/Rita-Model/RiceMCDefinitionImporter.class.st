"
I am an importer that visits MCDefinitions and creates IceDefinitions from them. I install those definitions into a corresponding package node.
"
Class {
	#name : 'RiceMCDefinitionImporter',
	#superclass : 'Object',
	#instVars : [
		'packageNode',
		'snapshot'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'private' }
RiceMCDefinitionImporter >> definitionForMethodContainerNamed: aString ifAbsent: aBlock [

	^ snapshot definitions
		detect: [ :e |
			"Both Monticello class and trait definition answer true"
			e isClassDefinition and: [ e className = aString ] ]
		ifNone: aBlock
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> ensureMethodOwnerNamed: ownerName isTrait: isTrait isExtension: isExtension [
	
	| newDefinition |	
	newDefinition := isExtension
		ifTrue: [
			RiceExtensionDefinition
				named: ownerName
				packageName: packageNode value name ]
		ifFalse: [ 
			isTrait
				ifFalse: [ RiceClassDefinition named: ownerName ]
				ifTrue: [ RiceTraitDefinition named: ownerName ] ].
	
	^ packageNode childAt: newDefinition key ifAbsentPut: [ newDefinition ]
]

{ #category : 'importing' }
RiceMCDefinitionImporter >> fill: aContainerDefinition from: aMCClassDefinition [
	"Copy the properties and the variables of a Monticello class or trait definition into plain values of the Rice definition"

	| propertyNames |
	propertyNames := MCClassDefinition instVarNames copyWithoutAll: #( name variables commentStamp ).
	aContainerDefinition
		propertyValues: (propertyNames inject: OrderedDictionary new into: [ :dictionary :propertyName |
			 dictionary
				 at: propertyName put: (aMCClassDefinition instVarNamed: propertyName);
				 yourself ]);
		variables: (aMCClassDefinition variables collect: [ :each | each name -> each class type ])
]

{ #category : 'testing' }
RiceMCDefinitionImporter >> isExtension: aString [ 
	
	self definitionForMethodContainerNamed: aString ifAbsent: [ ^ true ].
	^ false
]

{ #category : 'testing' }
RiceMCDefinitionImporter >> isTrait: aString [ 
	
	| definition |
	definition := self definitionForMethodContainerNamed: aString ifAbsent: [ ^ false ].
	^ definition isTraitDefinition
]

{ #category : 'accessing' }
RiceMCDefinitionImporter >> packageNode: anIcePackageNode [ 
	packageNode := anIcePackageNode
]

{ #category : 'accessing' }
RiceMCDefinitionImporter >> snapshot: aMCSnapshot [ 
	snapshot := aMCSnapshot
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitClassDefinition: aMCClassDefinition [

	| classDefinitionNode iceDefinition |
	classDefinitionNode := self ensureMethodOwnerNamed: aMCClassDefinition className isTrait: false isExtension: false.
	iceDefinition := classDefinitionNode value.
	self fill: iceDefinition from: aMCClassDefinition.
	iceDefinition definition: aMCClassDefinition fullDefinitionString.

	iceDefinition childrenDefinitions do: [ :each | classDefinitionNode addChild: each ].

	^ classDefinitionNode
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitClassTraitDefinition: aMCClassTraitDefinition [

	| classTraitDefinitionNode |
	classTraitDefinitionNode := self ensureMethodOwnerNamed: aMCClassTraitDefinition className isTrait: true isExtension: false.
	classTraitDefinitionNode value definition: aMCClassTraitDefinition definitionString.
	^ classTraitDefinitionNode
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitMetaclassDefinition: aMCClassDefinition [
	"We do nothing because of Monticello meta-model.
	
	The problem is that Monticello visitor does not launch the Metaclass visit if the metaclass does not have any class instance variables or Trait composition. We need this information all the time so we will generate it in the class visit.
	
	The concrete method it MCClassDefinition>>accept:"

]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitMethodDefinition: aMCMethodDefinition [ 
	
	| ownerName isMeta isTrait ownerNode iceNode iceDefinition |
	
	ownerName := aMCMethodDefinition className.
	isMeta := aMCMethodDefinition classIsMeta.
	isTrait := self isTrait: aMCMethodDefinition className.
	
	ownerNode := self
		ensureMethodOwnerNamed: ownerName
		isTrait: isTrait
		isExtension: (self isExtension: aMCMethodDefinition className).

	iceDefinition :=
		RiceMethodDefinition
			className: ownerName
			classIsMeta: isMeta
			protocol: aMCMethodDefinition protocol
			name: aMCMethodDefinition selector
			sourceCode: aMCMethodDefinition source.

	iceNode := ownerNode addChild: iceDefinition.

	iceDefinition childrenDefinitions do: [ :each |
		iceNode addChild: each ].
	
	^ iceNode 
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitOrganizationDefinition: aMCOrganizationDefinition [ 
	
	packageNode value categories: aMCOrganizationDefinition categories
]

{ #category : 'visiting' }
RiceMCDefinitionImporter >> visitTraitDefinition: aMCTraitDefinition [

	| traitDefinitionNode |
	traitDefinitionNode := self ensureMethodOwnerNamed: aMCTraitDefinition className isTrait: true isExtension: false.
	self fill: traitDefinitionNode value from: aMCTraitDefinition.
	traitDefinitionNode value definition: aMCTraitDefinition definitionString.
	^ traitDefinitionNode
]
