Class {
	#name : #ZuChangedMethodQueryTest,
	#superclass : #ClyMethodQueryTestCase,
	#category : #'Rita-PullRequests-Tests'
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
	super setUpEnvironment.
	environment
		addPlugin:
			(ZuEnvironmentPlugin new
				tmpSelectors: #(methodWithChange);
				yourself)
]

{ #category : #tests }
ZuChangedMethodQueryTest >> testDoesSelectChangedMethod [
	self assert: (query selectsMethod: self class >> #methodWithChange)
]

{ #category : #tests }
ZuChangedMethodQueryTest >> testDoesntSelectUnchangedMethod [
	self deny: (query selectsMethod: self class >> #methodWithoutChange)
]
