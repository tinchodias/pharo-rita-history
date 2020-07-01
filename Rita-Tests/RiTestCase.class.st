Class {
	#name : #RiTestCase,
	#superclass : #IceAbstractTestCase,
	#instVars : [
		'repository'
	],
	#category : #'Rita-Tests'
}

{ #category : #running }
RiTestCase >> buildRepository [
	repository := (RiRepository iceRepository: self repository)
		process;
		yourself

]

{ #category : #running }
RiTestCase >> checkoutBranch: aString [
	^ self repository checkoutBranch: aString
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
RiTestCase >> deleteBranch: aString [
	(self repository branchNamed: aString) delete.

	self flag: #todo. "Workaround: without this wait the image is broken after running the whole test suite"
	500 milliSeconds wait.

]

{ #category : #running }
RiTestCase >> newFixture [
	^ IceBasicRepositoryFixture inGit
]
