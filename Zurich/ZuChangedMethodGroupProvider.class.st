Class {
	#name : #ZuChangedMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #Zurich
}

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodGroupFor: arg1 from: arg2 [
	^ ClyMethodGroup named: 'changed' priority: 8.45 on: arg1
]

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodQueryFrom: arg1 [
	^ ZuChangedMethodQuery from: arg1
]
