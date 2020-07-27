Class {
	#name : #ZuChangedMethodQueryTest,
	#superclass : #ClyMethodQueryTestCase,
	#category : #'Zurich-Tests'
}

{ #category : #running }
ZuChangedMethodQueryTest >> createQuery [
	^ ZuChangedMethodQuery
		from: ClyClassScope
		of: self class
		in: environment
]

{ #category : #running }
ZuChangedMethodQueryTest >> methodWithChange [
	
]

{ #category : #running }
ZuChangedMethodQueryTest >> methodWithoutChange [
	
]

{ #category : #running }
ZuChangedMethodQueryTest >> setUpEnvironment [
	| tmp2 |
	super setUpEnvironment.
	tmp2 := ZuEnvironmentPlugin new.
	tmp2 tmpSelectors: #(#methodWithChange).
	environment addPlugin: tmp2 yourself
]

{ #category : #tests }
ZuChangedMethodQueryTest >> testDoesSelectChangedMethod [
	self assert: (query selectsMethod: self class >> #methodWithChange)
]

{ #category : #tests }
ZuChangedMethodQueryTest >> testDoesntSelectUnchangedMethod [
	self deny: (query selectsMethod: self class >> #methodWithoutChange)
]
