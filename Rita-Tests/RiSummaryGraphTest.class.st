"
A RiMarkSummaryModelTest is a test class for testing the behavior of RiMarkSummaryModel
"
Class {
	#name : #RiSummaryGraphTest,
	#superclass : #RiTestCase,
	#instVars : [
		'summaryGraph'
	],
	#category : #'Rita-Tests'
}

{ #category : #running }
RiSummaryGraphTest >> assert: aRiMarkSummaryElement summarizes: aNumberOfCommits markClasses: anArrayOfClasses [
	
	self assert: aRiMarkSummaryElement commits size equals: aNumberOfCommits.
	self
		assert: (aRiMarkSummaryElement marks collect: #class as: Array)
		equals: anArrayOfClasses
]

{ #category : #tests }
RiSummaryGraphTest >> buildSummaryGraph [
	self buildRepositoryModel.
	summaryGraph := RiSummaryGraph new
		repositoryModel: repositoryModel;
		process;
		yourself.
		
"	RiRepositoryBrowser openWith: repositoryModel.
	RiSummaryBrowser openWith: summaryGraph.
	1halt."
]

{ #category : #tests }
RiSummaryGraphTest >> testHiddenMerge [
	"
	input:

	3 		A
	|\
	| 2
	|/
	1 		B

	output:
	
	o 		A
	|
	o 		B

	"
	
	| c1 c2 |
	c1 := self commitWithMessage: '1'.
	self createTag: 'A'.
	c2 := self commitWithMessage: '2'.
	self commitWithMessage: '3' andParents: { c2. c1 }.
	self createTag: 'B'.

	self buildSummaryGraph.

	self assert: summaryGraph elements size equals: 2.
	self
		assert: summaryGraph elements first
		summarizes: 2
		markClasses: { RiTagMark. RiBranchMark. RiWorkingCopyMark }.
	self
		assert: summaryGraph elements second
		summarizes: 1
		markClasses: { RiTagMark }.

]

{ #category : #tests }
RiSummaryGraphTest >> testHiddenMerge2 [
	"
	input:

	7 		master
	|
	6		
	|\
	| 5
	|/
	4		
	|\
	| 3
	|/
	2
	|
	1 		A

	output:
	
	o 		master
	|
	o 		A

	"
	
	| c2 c3 c4 c5 |
	self commitWithMessage: '1'.
	self createTag: 'A'.

	c2 := self commitWithMessage: '2'.
	self checkoutBranch: 'tmp'.
	c3 := self commitWithMessage: '3'.
	self checkoutBranch: 'master'.
	c4 := self commitWithMessage: '4' andParents: { c2. c3 }.

	self checkoutBranch: 'tmp2'.
	c5 := self commitWithMessage: '5'.
	self checkoutBranch: 'master'.
	self commitWithMessage: '6' andParents: { c4. c5 }.

	self commitWithMessage: '7'.
	self deleteBranch: 'tmp'.
	self deleteBranch: 'tmp2'.

	self buildSummaryGraph.

	self assert: summaryGraph elements size equals: 2.
	self
		assert: summaryGraph elements first
		summarizes: 6
		markClasses: { RiBranchMark. RiWorkingCopyMark }.
	self
		assert: summaryGraph elements second
		summarizes: 1
		markClasses: { RiTagMark }.

]

{ #category : #tests }
RiSummaryGraphTest >> testMergeWithEmptyJoint [
	"
	input:

	6 		master
	|\
	5 |
	| 4 	dev
	3 |
	| 2
	|/
	1

	output:
	
	o 		master
	|\
	| o 	dev
	|/
	o

	"
	
	| c4 c5 |
	self commitWithMessage: '1'.
	self checkoutBranch: 'dev'.
	self commitWithMessage: '2'.
	self checkoutBranch: 'master'.
	self commitWithMessage: '3'.
	self checkoutBranch: 'dev'.
	c4 := self commitWithMessage: '4'.
	self checkoutBranch: 'master'.
	c5 := self commitWithMessage: '5'.
	self commitWithMessage: '6' andParents: { c5. c4 }.

	self buildSummaryGraph.

	self assert: summaryGraph elements size equals: 3.

	"master"
	self
		assert: summaryGraph elements first
		summarizes: 3
		markClasses: { RiBranchMark. RiWorkingCopyMark }.
		
	"dev"	
	self
		assert: summaryGraph elements second
		summarizes: 2
		markClasses: { RiBranchMark }.

	"empty joint"	
	self
		assert: summaryGraph elements third
		summarizes: 1
		markClasses: { }.

]

{ #category : #tests }
RiSummaryGraphTest >> testSingleBranch [
	"
	input:

	3 		master
	|
	2
	|
	1

	output:
	
	o 		master

	"

	self commitWithMessage: '1'.
	self commitWithMessage: '2'.
	self commitWithMessage: '3'.

	self buildSummaryGraph.

	self assert: summaryGraph elements size equals: 1.
	
	"master"
	self
		assert: summaryGraph elements first
		summarizes: 3
		markClasses: { RiBranchMark. RiWorkingCopyMark }.
]

{ #category : #tests }
RiSummaryGraphTest >> testSingleBranchWithTag [
	"
	input:

	2 		master
	|
	1 		A

	output:
	
	o 		master
	|
	o 		A

	"
	
	self commitWithMessage: '1'.
	self createTag: 'A'.
	self commitWithMessage: '2'.
	
	self buildSummaryGraph.

	self assert: summaryGraph elements size equals: 2.
	self
		assert: summaryGraph elements first
		summarizes: 1
		markClasses: { RiBranchMark. RiWorkingCopyMark }.
	self
		assert: summaryGraph elements second
		summarizes: 1
		markClasses: { RiTagMark }.

]
