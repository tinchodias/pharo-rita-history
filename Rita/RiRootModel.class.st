Class {
	#name : #RiRootModel,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'considerOnlyChanged'
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
]

{ #category : #accessing }
RiRootModel >> repositories [
	^ repositories
]

{ #category : #accessing }
RiRootModel >> repositories: aCollection [ 
	repositories := aCollection
]
