"
I represent a trait read from an Iceberg repository, either from a commit or from the working directory in disk.

My contents is the trait definition.

See my superclasses for more information.
"
Class {
	#name : #RiceTraitDefinition,
	#superclass : #RiceMethodContainerDefinition,
	#category : #'Rita-Model-Changes'
}

{ #category : #visiting }
RiceTraitDefinition >> accept: aVisitor [
	
	^ aVisitor visitTraitDefinition: self
]

{ #category : #patching }
RiceTraitDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [
	
	aMCPatcher
		modifyDefinition: anotherIceDefinition asMCDefinition
		to: self asMCDefinition
]

{ #category : #patching }
RiceTraitDefinition >> addToPatcher: aMCPatcher [ 
	
	"We should not handle metaclasses if their mcDefinition is nil.
	They should be added automatically when added the instance side."
	mcDefinition ifNil: [ ^ self ].

	"We should only be in this case if there is not instace-side changes."
	aMCPatcher addDefinition: self asMCDefinition
]

{ #category : #accessing }
RiceTraitDefinition >> contents [
	^ mcDefinition definitionString
]

{ #category : #'as yet unclassified' }
RiceTraitDefinition >> icon [
	^ self iconNamed: #trait
]

{ #category : #testing }
RiceTraitDefinition >> isTraitDefinition [

	^ true
]

{ #category : #patching }
RiceTraitDefinition >> removeFromPatcher: aMCPatcher [ 
	
	"We should not handle metaclasses. They will be added automatically when added the instance side"
	mcDefinition ifNil: [ ^ self ].
	
	aMCPatcher removeDefinition: self asMCDefinition
]
