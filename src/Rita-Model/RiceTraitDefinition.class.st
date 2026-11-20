"
I represent a trait read from an Iceberg repository, either from a commit or from the working directory in disk.

My contents is the trait definition.

See my superclasses for more information.
"
Class {
	#name : 'RiceTraitDefinition',
	#superclass : 'RiceMethodContainerDefinition',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceTraitDefinition >> accept: aVisitor [
	
	^ aVisitor visitTraitDefinition: self
]

{ #category : 'accessing' }
RiceTraitDefinition >> contents [

	^ self definition
]

{ #category : 'as yet unclassified' }
RiceTraitDefinition >> icon [
	^ self iconNamed: #trait
]

{ #category : 'testing' }
RiceTraitDefinition >> isTraitDefinition [

	^ true
]
