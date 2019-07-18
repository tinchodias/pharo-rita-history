Class {
	#name : #HiMSearchModelTest,
	#superclass : #TestCase,
	#instVars : [
		'search',
		'root1',
		'root2',
		'child1',
		'child2',
		'results'
	],
	#category : #'Rita-Navigator-Tests'
}

{ #category : #tests }
HiMSearchModelTest >> setUp [
	root1 := HiMNode for: 'root1'.
	root2 := HiMNode for: 'root2'.
	child1 := HiMNode for: 'child1'.
	child2 := HiMNode for: 'child2'.
	root1 addChild: child1.
	root2 addChild: child2.
	root1 addOutgoingLinkTo: child2.

	search := HiMSearch new.
	search topParentNodes: { root1. root2 }.

]

{ #category : #tests }
HiMSearchModelTest >> testSearchEmptyText [
	
	search text: ''.
	results := search execute.
	
	self assertEmpty: results nodes.
	self deny: results hasResults.
]

{ #category : #tests }
HiMSearchModelTest >> testSearchOneChild [
	
	search text: 'child1'.
	results := search execute.
	
	self assert: results nodes equals: { child1 }.
	self assert: results currentIndex equals: 1.
	
	results goToNextResult.
	self assert: results currentIndex equals: 1.

	results goToPreviousResult.
	self assert: results currentIndex equals: 1.

]

{ #category : #tests }
HiMSearchModelTest >> testSearchTwoRoots [
	
	search text: 'roo'.
	results := search execute.
	
	self assert: results nodes equals: { root1. root2 }.
	self assert: results currentIndex equals: 1.
	
	results goToNextResult.
	self assert: results currentIndex equals: 2.
	results goToNextResult.
	self assert: results currentIndex equals: 1.

	results goToPreviousResult.
	self assert: results currentIndex equals: 2.
	results goToPreviousResult.
	self assert: results currentIndex equals: 1.

]
