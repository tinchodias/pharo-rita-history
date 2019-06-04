Class {
	#name : #RiTestCase,
	#superclass : #IceAbstractTestCase,
	#instVars : [
		'repositoryModel'
	],
	#category : #'Rita-Tests'
}

{ #category : #running }
RiTestCase >> buildRepositoryModel [
	repositoryModel := RiRepositoryModel new
		repository: self repository;
		process;
		yourself

]

{ #category : #running }
RiTestCase >> commitWithMessage: aString [
	^ self repository workingCopy
		commitChanges: self repository workingCopyDiff
		withMessage: aString
		force: true
]

{ #category : #running }
RiTestCase >> commitWithMessage: aString andParents: aCollection [ 
	^ self repository
		commitIndexWithMessage: aString
		andParents: aCollection

]

{ #category : #running }
RiTestCase >> createTag: aString [
	^ self repository createTag: aString
]

{ #category : #running }
RiTestCase >> newFixture [
	^ IceBasicRepositoryFixture inGit
]
