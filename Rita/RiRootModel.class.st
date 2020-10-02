"
I'm a view model for the main (root) repositories browser.
"
Class {
	#name : #RiRootModel,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'considerOnlyChanged',
		'isExpanded',
		'connectHierarchies',
		'flyDiff',
		'showPackages',
		'aesthetics',
		'actionsAnnouncer'
	],
	#category : #'Rita-UI-Models'
}

{ #category : #'instance creation' }
RiRootModel class >> newWithRegisteredRepositories [

	| repositories |
	repositories := (IceRepository registry 
		sorted: [ :a :b | a name asLowercase < b name asLowercase ])
		collect: [ :each | RiRepository iceRepository: each ].

	^ self new
		repositories: repositories;
		yourself.

]

{ #category : #accessing }
RiRootModel >> actionsAnnouncer [
	^ actionsAnnouncer
]

{ #category : #accessing }
RiRootModel >> aesthetics [
	^ aesthetics
]

{ #category : #accessing }
RiRootModel >> announceAction: aSymbol iceNode: iceNode [

	actionsAnnouncer announce: 
		(RiBasicActionAnnouncement new
			 kind: aSymbol;
			 data: iceNode asString;
			 yourself)

]

{ #category : #accessing }
RiRootModel >> connectHierarchies [
	^ connectHierarchies
]

{ #category : #accessing }
RiRootModel >> connectHierarchies: anObject [
	connectHierarchies := anObject
]

{ #category : #accessing }
RiRootModel >> considerOnlyChanged [
	^ considerOnlyChanged
]

{ #category : #accessing }
RiRootModel >> considerOnlyChanged: aBoolean [
	considerOnlyChanged := aBoolean
]

{ #category : #accessing }
RiRootModel >> flyDiff [
	^ flyDiff
]

{ #category : #accessing }
RiRootModel >> flyDiff: anObject [
	flyDiff := anObject
]

{ #category : #initialization }
RiRootModel >> initialize [
	super initialize.
	aesthetics := RiAestheticsModel new.
	considerOnlyChanged := true.
	isExpanded := true.
	connectHierarchies := true.
	flyDiff := true.
	showPackages := false.
	actionsAnnouncer := Announcer new.
]

{ #category : #accessing }
RiRootModel >> isExpanded [
	^ isExpanded
]

{ #category : #accessing }
RiRootModel >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #accessing }
RiRootModel >> repositories [
	^ repositories
]

{ #category : #accessing }
RiRootModel >> repositories: aCollection [ 
	repositories := aCollection
]

{ #category : #accessing }
RiRootModel >> showPackages [
	^ showPackages
]

{ #category : #accessing }
RiRootModel >> showPackages: aBoolean [
	showPackages := aBoolean
]

{ #category : #accessing }
RiRootModel >> toggle: aSymbol [
	self
		perform: aSymbol asMutator
		with: (self perform: aSymbol) not
]
