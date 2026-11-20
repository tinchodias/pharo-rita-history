"
I check that Rita-Model stays independent of the backends: it must not reference Iceberg, Monticello or libgit classes, so another backend can be added.
"
Class {
	#name : 'RiModelIndependenceTest',
	#superclass : 'TestCase',
	#category : 'Rita-Tests-Model',
	#package : 'Rita-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
RiModelIndependenceTest >> testModelReferencesNoBackendClass [

	| offenders |
	offenders := (PackageOrganizer default packageNamed: 'Rita-Model') methods select: [ :method |
		             method ast variableNodes anySatisfy: [ :node | node isGlobalVariable and: [ #( 'Ice' 'MC' 'LGit' ) anySatisfy: [ :prefix | node name beginsWith: prefix ] ] ] ].
	self assertEmpty: (offenders collect: #printString)
]
