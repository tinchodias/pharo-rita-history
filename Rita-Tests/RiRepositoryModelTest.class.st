Class {
	#name : #RiRepositoryModelTest,
	#superclass : #RiTestCase,
	#category : #'Rita-Tests'
}

{ #category : #tests }
RiRepositoryModelTest >> testMerge [
	"
	input:

	3 		B
	|\
	| 2
	|/
	1 		A

	"
	
	| c1 c2 c3 e1 e2 e3 |
	c1 := self commitWithMessage: '1'.
	self createTag: 'A'.
	c2 := self commitWithMessage: '2'.
	c3 := self commitWithMessage: '3' andParents: { c2. c1 }.
	self createTag: 'B'.

	self buildRepositoryModel.

	self assert: repositoryModel elements size equals: 3.
	self assert: repositoryModel elementMarks size equals: 3.

	e1 := repositoryModel elementByCommit at: c1.
	e2 := repositoryModel elementByCommit at: c2.
	e3 := repositoryModel elementByCommit at: c3.

	"ancestors"
	self assert: e1 ancestors isEmpty.
	self assert: e2 ancestors equals: { e1 }.
	self assert: e3 ancestors equals: { e2. e1 }.
	
	"children"
	self assert: e1 children asArray equals: { e2. e3 }.
	self assert: e2 children asArray equals: { e3 }.
	self assert: e3 children asArray isEmpty.

]

{ #category : #tests }
RiRepositoryModelTest >> testSimple [
	"
	input:

	3 		A
	|
	2
	|
	1

	"

	self commitWithMessage: '1'.
	self commitWithMessage: '2'.
	self commitWithMessage: '3'.
	self createTag: 'A'.
	
	self buildRepositoryModel.

	self assert: repositoryModel elements size equals: 3.
	self assert: repositoryModel elementMarks size equals: 2.

]
