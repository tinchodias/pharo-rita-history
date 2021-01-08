"
I'm responsible of creating a method group for Calypso that gathers the methods that have a change.
"
Class {
	#name : #ZuChangedMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodGroupFor: aMethodQuery from: aClassScope [

	^ ClyMethodGroup named: 'changed' priority: 8.45 on: aMethodQuery
]

{ #category : #'building groups' }
ZuChangedMethodGroupProvider >> createMethodQueryFrom: aClassScope [

	^ ZuChangedMethodQuery from: aClassScope
]
