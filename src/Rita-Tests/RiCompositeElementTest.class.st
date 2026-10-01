Class {
	#name : 'RiCompositeElementTest',
	#superclass : 'RiTestCase',
	#category : 'Rita-Tests',
	#package : 'Rita-Tests'
}

{ #category : 'tests' }
RiCompositeElementTest >> testACommitAndACompositeAnswerTheSameEndpointApi [

	| c1 c2 c3 e1 e2 e3 composite |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	c3 := self commitWithMessage: '3'.
	self buildRepository.
	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	e3 := repository elementByCommit at: c3.
	
	"A commit is its own diff target and starts from its parent:"
	self assert: e2 targetRiElement equals: e2.
	self assert: e2 sourceRiElement equals: e1.
	
	"A composite starts at the oldest member's ancestor outside of itself and ends at its newest member:"
	composite := RiCompositeElement of: {
			             e3.
			             e2 }.
			
	self assert: composite sourceRiElement equals: e1.
	self assert: composite targetRiElement equals: e3.
	
	"The uncommitted working copy is not a commit, so it is not a valid diff target:"
	self assert: (RiUncommitedWorkingCopy new referenceCommit: e2) targetRiElement isNil
]

{ #category : 'tests' }
RiCompositeElementTest >> testACompositeNeedsAtLeastTwoElements [
	"A composite is always made of at least two elements: a single selected commit is not a composite."

	| c1 c2 e1 composite |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	self buildRepository.
	e1 := repository elementByCommit at: c1.
	
	"An empty collection is refused:"
	self should: [ RiCompositeElement of: #(  ) ] raise: Error.
	
	"A single element is refused too:"
	self should: [ RiCompositeElement of: { e1 } ] raise: Error.
	
	"Two distinct elements are accepted, ordered newest first:"
	composite := RiCompositeElement of: repository elements.
	self assert: composite size equals: 2
]

{ #category : 'tests' }
RiCompositeElementTest >> testMergeSelection [

	| c1 c2 c3 e1 e2 e3 composite |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	c3 := self commitWithMessage: '3' andParents: {
			      c2.
			      c1 }.
	self buildRepository.
	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	e3 := repository elementByCommit at: c3.
	composite := RiCompositeElement of: {
			             e3.
			             e2 }.
	self assert: composite sourceRiElement equals: e1.
	self assert: composite targetRiElement equals: e3
]

{ #category : 'tests' }
RiCompositeElementTest >> testSelectingTheRootCommitHasNoSource [

	| c1 c2 e1 e2 composite |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	self buildRepository.
	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	"The root commit has no ancestor left to diff from:"
	composite := RiCompositeElement of: {
			             e2.
			             e1 }.
	self assert: composite sourceRiElement isNil.
	self assert: composite targetRiElement equals: e2
]

{ #category : 'tests' }
RiCompositeElementTest >> testTheUncommitedWorkingCopyIsNeverATarget [

	| c1 c2 e1 e2 workingCopy composite |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	self buildRepository.
	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	workingCopy := RiUncommitedWorkingCopy new referenceCommit: e2.
	
	"The uncommitted working copy comes first because it is the newest row of the list:"
	composite := RiCompositeElement of: {
			             workingCopy.
			             e2 }.
	self assert: composite targetRiElement equals: e2.
	self assert: composite sourceRiElement equals: e1
]

{ #category : 'tests' }
RiCompositeElementTest >> testTheWholeHistoryHasNoSource [
	| composite |
	self commitWithMessage: '1'.
	self commitWithMessage: '2'.

	self buildRepository.

	composite := RiCompositeElement of: repository elements.
	self assert: composite size equals: 2.
	self assert: composite sourceRiElement isNil
]
