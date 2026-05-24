"
I'm a view model for the main (root) repositories browser.
"
Class {
	#name : 'RiRootModel',
	#superclass : 'Object',
	#instVars : [
		'repositories',
		'considerOnlyChanged',
		'connectHierarchies',
		'actionsAnnouncer'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiRootModel class >> newWithRegisteredRepositories [

	| repositories |
	repositories := (IceRepository registry 
		sorted: [ :a :b | a name asLowercase < b name asLowercase ])
		collect: [ :each | RiRepository iceRepository: each ].

	^ self new
		repositories: repositories;
		yourself.

]

{ #category : 'accessing' }
RiRootModel >> actionsAnnouncer [
	^ actionsAnnouncer
]

{ #category : 'accessing' }
RiRootModel >> announceAction: aSymbol iceNode: iceNode [

	iceNode ifNil: [ ^self ].

	actionsAnnouncer announce: 
		(RiBasicActionAnnouncement new
			 kind: aSymbol;
			 data: iceNode key asString;
			 yourself)

]

{ #category : 'accessing' }
RiRootModel >> connectHierarchies [
	^ connectHierarchies
]

{ #category : 'accessing' }
RiRootModel >> connectHierarchies: anObject [
	connectHierarchies := anObject
]

{ #category : 'accessing' }
RiRootModel >> considerOnlyChanged [
	^ considerOnlyChanged
]

{ #category : 'accessing' }
RiRootModel >> considerOnlyChanged: aBoolean [
	considerOnlyChanged := aBoolean
]

{ #category : 'initialization' }
RiRootModel >> initialize [

	super initialize.
	considerOnlyChanged := true.
	connectHierarchies := true.
	actionsAnnouncer := Announcer new
]

{ #category : 'accessing' }
RiRootModel >> repositories [
	^ repositories
]

{ #category : 'accessing' }
RiRootModel >> repositories: aCollection [ 
	repositories := aCollection
]

{ #category : 'accessing' }
RiRootModel >> toggle: aSymbol [

	self perform: aSymbol asMutator with: (self perform: aSymbol) not
]
