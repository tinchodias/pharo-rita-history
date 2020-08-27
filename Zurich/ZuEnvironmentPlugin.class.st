Class {
	#name : #ZuEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#instVars : [
		'iceDiff'
	],
	#category : #Zurich
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
ZuEnvironmentPlugin >> doesMethodHaveChange: arg1 [
	iceDiff tree allChildrenDo: [ :each |
		| def |
		def := each value definition.
		(def isMethodDefinition and: [ 
		def selector = arg1 selector and: [ 
		def className = arg1 origin name ] ]) ifTrue: [ ^ true ] ].
	
	^ false
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesPackageHaveChange: aPackage [
	^ (aPackage definedClasses anySatisfy: [ :each | self doesClassHaveChange: each ]) or: [
		aPackage extensionMethods anySatisfy: [ :each | self doesMethodHaveChange: each ] ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceDiff [
	^ iceDiff
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceDiff: anIceDiff [
	iceDiff := anIceDiff
]
