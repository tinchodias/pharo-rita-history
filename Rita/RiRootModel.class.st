Class {
	#name : #RiRootModel,
	#superclass : #Object,
	#instVars : [
		'dynamicPageModels',
		'repositories'
	],
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiRootModel >> initialize [
	super initialize.
	repositories := IceRepository registry
		collect: [ :anIceRepository | 
			RiRepository new
				iceRepository: anIceRepository;
				yourself ].
	dynamicPageModels := OrderedCollection new
]

{ #category : #accessing }
RiRootModel >> repositories [
	^ repositories
]
