"
I am an importer of MCPackages into an IceNode. I am created from a version and a node. I calculate the snapshot of that definition and import all those definitions into my node, delegating to a IceMCDefinitionImporter.
"
Class {
	#name : 'RiceMCPackageImporter',
	#superclass : 'Object',
	#instVars : [
		'packageName',
		'version',
		'package'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'private' }
RiceMCPackageImporter >> definitionsOfFileNamed: aFileName [
	"Answer the Monticello definitions of one Tonel file of my package at my version, reading only that file. I answer none when the file does not exist in this version or cannot be parsed."

	| reader file |
	reader := IceLibgitTonelReader on: version libgitCommit iceVersion: (version versionFor: self package).
	file := reader packageDirectory entries
		        detect: [ :each | (reader fileUtils fileName: each) = aFileName ]
		        ifNone: [ ^ #(  ) ].
	^ reader parseTonelFile: file onError: [ :error | #(  ) ]
]

{ #category : 'importing' }
RiceMCPackageImporter >> importFileNamed: aFileName onto: aNode [
	"Import the definitions of one changed file of my package, and the organization of the package (package.st). The rest of the package is not imported: the commit did not change it, so it shows no difference. The class file of each class my methods belong to is read only to tell whether that class is defined in my package, so that its methods are not shown as extensions. The package node is created even when the file is absent in this version, so that both sides of a diff have it."

	| packageNode fileNames definitions lookupFileNames snapshot |
	(version includesPackageNamed: self packageName) ifFalse: [ ^ self ].

	packageNode := aNode childAt: self packageName ifAbsentPut: [ RicePackageDefinition named: self packageName ].
	packageNode value path: packageNode path.

	fileNames := {
		             'package.st'.
		             aFileName } asSet.
	definitions := fileNames asArray flatCollect: [ :each | self definitionsOfFileNamed: each ].
	lookupFileNames := (definitions
		                    select: [ :each | each isMethodDefinition ]
		                    thenCollect: [ :each | each className , '.class.st' ]) asSet reject: [ :each | fileNames includes: each ].
	snapshot := MCSnapshot fromDefinitions: definitions , (lookupFileNames asArray flatCollect: [ :each | self definitionsOfFileNamed: each ]).
	definitions do: [ :definition |
			definition accept: (RiceMCDefinitionImporter new
					 packageNode: packageNode;
					 snapshot: snapshot;
					 yourself) ].
	^ packageNode
]

{ #category : 'importing' }
RiceMCPackageImporter >> importOn: aNode [
	
	| packageNode snapshot definition |
	"If the version does not include the package, we do not calculate a snapshot nor import it"
	(version includesPackageNamed: self packageName)
		ifFalse: [ ^ self ].
	
	definition := RicePackageDefinition named: self packageName.
	packageNode := aNode addChild: definition.
	definition path: packageNode path.
	
	snapshot := self snapshot.
	snapshot definitions do: [ :e | 
		e accept: (RiceMCDefinitionImporter new
			packageNode: packageNode;
			snapshot: snapshot;
			yourself) ].
	^ packageNode
]

{ #category : 'accessing' }
RiceMCPackageImporter >> package [
	^ package
]

{ #category : 'accessing' }
RiceMCPackageImporter >> package: aPackage [
	
	package := aPackage
]

{ #category : 'accessing' }
RiceMCPackageImporter >> packageName [
	
	^ self package name
]

{ #category : 'accessing' }
RiceMCPackageImporter >> snapshot [
	
	^ version snapshotForPackage: self package
]

{ #category : 'accessing' }
RiceMCPackageImporter >> version: aVersion [
	
	version := aVersion
]
