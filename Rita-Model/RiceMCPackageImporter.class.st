"
I am an importer of MCPackages into an IceNode. I am created from a version and a node. I calculate the snapshot of that definition and import all those definitions into my node, delegating to a IceMCDefinitionImporter.
"
Class {
	#name : #RiceMCPackageImporter,
	#superclass : #Object,
	#instVars : [
		'packageName',
		'version',
		'package'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #importing }
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

{ #category : #accessing }
RiceMCPackageImporter >> package [
	^ package
]

{ #category : #accessing }
RiceMCPackageImporter >> package: aPackage [
	
	package := aPackage
]

{ #category : #accessing }
RiceMCPackageImporter >> packageName [
	
	^ self package name
]

{ #category : #accessing }
RiceMCPackageImporter >> snapshot [
	
	^ version snapshotForPackage: self package
]

{ #category : #accessing }
RiceMCPackageImporter >> version: aVersion [
	
	version := aVersion
]
