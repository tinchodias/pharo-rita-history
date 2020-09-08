Class {
	#name : #ZuEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#instVars : [
		'pullRequestModel'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #'method groups' }
ZuEnvironmentPlugin >> collectMethodGroupProviders [
	^ { ZuChangedMethodGroupProvider new }
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofClass: aClass [
	(self doesClassHaveChange: aClass)
		ifTrue: [ anItem markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofMethod: aMethod [
	(self doesMethodHaveChange: aMethod)
		ifTrue: [ anItem markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: anItem ofPackage: aPackage [
	(self doesPackageHaveChange: aPackage)
		ifTrue: [ anItem markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesClassHaveChange: aClass [
	^ aClass localMethods
		anySatisfy: [ :each | self doesMethodHaveChange: each ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesMethodHaveChange: aMethod [
	self pullRequestDiff tree allChildrenDo: [ :each |
		| def |
		def := each value definition.
		(def isMethodDefinition and: [ 
		def selector = aMethod selector and: [ 
		def className = aMethod origin name ] ]) ifTrue: [ ^ true ] ].
	
	^ false
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesPackageHaveChange: aPackage [
	^ (aPackage definedClasses anySatisfy: [ :each | self doesClassHaveChange: each ]) or: [
		aPackage extensionMethods anySatisfy: [ :each | self doesMethodHaveChange: each ] ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestConversationItems [
	^ pullRequestModel at: #pullRequestConversationItems
]

{ #category : #accessing }
ZuEnvironmentPlugin >> pullRequestDiff [
	^ pullRequestModel at: #pullRequestDiff
]

{ #category : #initialization }
ZuEnvironmentPlugin >> pullRequestModel: aCollection [ 
	pullRequestModel := aCollection
]

{ #category : #'as yet unclassified' }
ZuEnvironmentPlugin >> toolModelFor: aRGMethod ifPresent: presentBlock ifAbsent: absentBlock [ 

	self pullRequestDiff tree allChildrenDo: [ :each |
		| def |
		def := each value definition.
		(def isMethodDefinition and: [ 
		def selector = aRGMethod selector and: [ 
		def className = aRGMethod origin name ] ]) ifTrue: [
			^ presentBlock value: (pullRequestModel copy
				at: #selectedIceNode put: each;
				yourself) ] ].

	^ absentBlock value
]
