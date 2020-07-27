Class {
	#name : #ZuEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#instVars : [
		'tmpSelectors'
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
	^ self tmpSelectors includes: arg1 selector
]

{ #category : #'item decoration' }
ZuEnvironmentPlugin >> doesPackageHaveChange: arg1 [
	^ (arg1 definedClasses
		anySatisfy: [ :arg2 | self doesClassHaveChange: arg2 ])
		or: [ arg1 extensionMethods
				anySatisfy: [ :arg3 | self doesMethodHaveChange: arg3 ] ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> tmpSelectors [
	| tmp2 |
	tmp2 := tmpSelectors.
	^ tmp2 ifNil: [ #() ] ifNotNil: [ tmp2 ]
]

{ #category : #accessing }
ZuEnvironmentPlugin >> tmpSelectors: arg1 [
	tmpSelectors := arg1
]
