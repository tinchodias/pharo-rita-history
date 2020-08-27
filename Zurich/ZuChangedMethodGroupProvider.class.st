Class {
	#name : #ZuChangedMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #Zurich
}

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodGroupFor: aMethodQuery from: aClassScope [
	^ ClyMethodGroup named: 'changed' priority: 8.45 on: aMethodQuery
]

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodQueryFrom: aClassScope [
	^ ZuChangedMethodQuery from: aClassScope
]
