Class {
	#name : #RiRootModel,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'considerOnlyChanged',
		'showClassNames'
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
RiRootModel >> considerOnlyChanged [
	^ considerOnlyChanged
]

{ #category : #accessing }
RiRootModel >> considerOnlyChanged: aBoolean [
	considerOnlyChanged := aBoolean
]

{ #category : #initialization }
RiRootModel >> initialize [
	super initialize.
	considerOnlyChanged := true.
	showClassNames := true.
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
RiRootModel >> showClassNames [
	^ showClassNames
]

{ #category : #accessing }
RiRootModel >> showClassNames: anObject [
	showClassNames := anObject
]
