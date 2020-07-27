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
	^ {ZuChangedMethodGroupProvider new}
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: arg1 ofClass: arg2 [
	(self doesClassHaveChange: arg2)
		ifTrue: [ arg1 markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: arg1 ofMethod: arg2 [
	(self doesMethodHaveChange: arg2)
		ifTrue: [ arg1 markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> decorateBrowserItem: arg1 ofPackage: arg2 [
	(self doesPackageHaveChange: arg2)
		ifTrue: [ arg1 markWith: ZuChangedTag ]
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesClassHaveChange: arg1 [
	^ arg1 localMethods
		anySatisfy: [ :arg2 | self doesMethodHaveChange: arg2 ]
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
ZuEnvironmentPlugin >> doesPackageHaveChange: arg1 [
	^ (arg1 definedClasses
		anySatisfy: [ :arg2 | self doesClassHaveChange: arg2 ])
		or: [ arg1 extensionMethods
				anySatisfy: [ :arg3 | self doesMethodHaveChange: arg3 ] ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceDiff [
	^ iceDiff
]

{ #category : #accessing }
ZuEnvironmentPlugin >> iceDiff: anIceDiff [
	iceDiff := anIceDiff
]
