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

	^ self iceNodeFor: aMethod ifPresent: [ true ] ifAbsent: [ false ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesPackageHaveChange: aPackage [
	^ (aPackage definedClasses anySatisfy: [ :each | self doesClassHaveChange: each ]) or: [
		aPackage extensionMethods anySatisfy: [ :each | self doesMethodHaveChange: each ] ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceNodeFor: aMethod ifPresent: presentBlock ifAbsent: absentBlock [ 

	self pullRequestDiff tree allChildrenDo: [ :each |
		| def |
		def := each value definition.
		(def isMethodDefinition and: [
		def selector = aMethod selector and: [
		def classIsMeta = aMethod isMetaSide and: [
		def className = aMethod origin theNonMetaClass name ] ] ]) 
			ifTrue: [ ^ presentBlock cull: each ] ].

	^ absentBlock value
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
