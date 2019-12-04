Class {
	#name : #RiRootModel,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'considerOnlyChanged',
		'isExpanded',
		'connectHierarchies',
		'showMethodsLOC',
		'flyDiff'
	],
	#category : #'Rita-UI'
}

{ #category : #'instance creation' }
RiRootModel class >> newWithRegisteredRepositories [

	| repositories |
	repositories := IceRepository registry
		collect: [ :anIceRepository | 
			RiRepository new
				iceRepository: anIceRepository;
				yourself ].

	^ self new
		repositories: repositories;
		yourself.

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
	considerOnlyChanged := true.
	isExpanded := true.
	connectHierarchies := true.
	showMethodsLOC := true.
	flyDiff := false.
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
RiRootModel >> showMethodsLOC [
	^ showMethodsLOC
]

{ #category : #accessing }
RiRootModel >> showMethodsLOC: anObject [
	showMethodsLOC := anObject
]

{ #category : #accessing }
RiRootModel >> toggle: aSymbol [
	self
		perform: aSymbol asMutator
		with: (self perform: aSymbol) not
]
