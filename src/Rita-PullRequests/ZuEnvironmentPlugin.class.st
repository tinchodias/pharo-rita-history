"
I'm a plugin for Calypso, the main entry point for the Rita-PullRequests Calypso extension.



"
Class {
	#name : #ZuEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#instVars : [
		'pullRequestModel',
		'cache'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #enumerating }
ZuEnvironmentPlugin >> cacheClass: aClass propertyDo: aUnaryBlock [

	| subProperties |
	subProperties := OrderedCollection new.

	aClass localMethods, aClass classSide localMethods do: [ :each |
		self cacheMethod: each propertyDo: [ :p |
			subProperties add: p ] ].

	subProperties ifNotEmpty: [
		| aProperty |
		aProperty := ZuChangeProperty new
			matchingIceNode: subProperties anyOne matchingIceNode parent; "FIX"
			plugin: self;
			yourself.
		cache at: aClass put: aProperty.
		aUnaryBlock	value: aProperty ]

]

{ #category : #enumerating }
ZuEnvironmentPlugin >> cacheExtensionMethod: aMethod propertiesDo: aUnaryBlock [ 

	self
		iceNodeFor: aMethod
		ifPresent: [ :iceNode |
			| aProperty |
			aProperty := ZuChangeProperty new
				matchingIceNode: iceNode;
				plugin: self;
				yourself.
			
			cache at: aMethod put: aProperty.
			aUnaryBlock	value: aProperty ]
		ifAbsent: [ ]

]

{ #category : #enumerating }
ZuEnvironmentPlugin >> cacheMethod: aMethod propertyDo: aUnaryBlock [ 

	self
		iceNodeFor: aMethod
		ifPresent: [ :iceNode |
			| aProperty |
			aProperty := ZuChangeProperty new
				matchingIceNode: iceNode;
				plugin: self;
				yourself.
			
			cache at: aMethod put: aProperty.
			aUnaryBlock	value: aProperty ]
		ifAbsent: [ ]

]

{ #category : #enumerating }
ZuEnvironmentPlugin >> cachePackage: aPackage propertyDo: aUnaryBlock [

	| subProperties |
	subProperties := OrderedCollection new.

	aPackage definedClasses do: [ :each |
		self cacheClass: each propertyDo: [ :p |
			subProperties add: p ] ].
	
	aPackage extensionMethods do: [ :each |
		self cacheExtensionMethod: each propertiesDo: [ :ps |
			subProperties addAll: ps ] ].

	subProperties ifNotEmpty: [
		| aProperty |
		aProperty := ZuChangeProperty new
			matchingIceNode: subProperties anyOne matchingIceNode parent; "FIX"
			plugin: self;
			yourself.
		cache at: aPackage put: aProperty.
		aUnaryBlock	value: aProperty ]

]

{ #category : #'method groups' }
ZuEnvironmentPlugin >> collectMetadataOfPackages: aQueryResult [

	pullRequestModel ifNil: [ ^self ].

	aQueryResult items do: [ :each |
		self cachePackage: each propertyDo: [:p | ] ].

]

{ #category : #'method groups' }
ZuEnvironmentPlugin >> collectMethodGroupProviders [

	^ { ZuChangedMethodGroupProvider new }
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofClass: aClass [

	cache at: aClass ifPresent: [ :p | anItem addProperty: p ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofMethod: aMethod [

	cache at: aMethod ifPresent: [ :p | anItem addProperty: p ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofPackage: aPackage [

	cache at: aPackage ifPresent: [ :p | anItem addProperty: p ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesMethodHaveChange: aMethod [

	^ cache includesKey: aMethod
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceNodeFor: aMethod ifPresent: presentBlock ifAbsent: absentBlock [

	self pullRequestDiff tree allChildrenDo: [ :each | 
		| def |
		def := each value definition.
		(def isMethodDefinition and: [ 
			 def selector = aMethod selector and: [ 
				 def classIsMeta = aMethod isMetaSide and: [ 
					 def ownerName = aMethod origin theNonMetaClass name ] ] ]) 
			ifTrue: [ ^ presentBlock cull: each ] ].

	^ absentBlock value
]

{ #category : #initialization }
ZuEnvironmentPlugin >> initialize [

	super initialize.
	cache := IdentityDictionary new
]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestConversationItems [

	^ pullRequestModel at: #pullRequestConversationItems
]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestConversationItemsConsideringChildrenFor: anIceNode [

	self flag: #todo. "Why had to use key?"
	^ self pullRequestConversationItems select: [ :each |
		each hasMapping and: [ anIceNode anySatisfy: [:any | any key = each mapping iceNode key ] ] ]

]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestConversationItemsFor: anIceNode [
	
	^ self pullRequestConversationItems select: [ :each |
		each hasMapping and: [ each mapping iceNode == anIceNode ] ]

]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestDiff [

	^ pullRequestModel at: #pullRequestDiff
]

{ #category : #initialization }
ZuEnvironmentPlugin >> pullRequestModel: aCollection [

	pullRequestModel := aCollection
]

{ #category : #accessing }
ZuEnvironmentPlugin >> toolModelFor: aMethod ifPresent: presentBlock ifAbsent: absentBlock [

	^ self
		  iceNodeFor: aMethod
		  ifPresent: [ :iceNode | 
			  presentBlock value: (pullRequestModel copy
					   at: #selectedIceNode put: iceNode;
					   yourself) ]
		  ifAbsent: absentBlock
]
