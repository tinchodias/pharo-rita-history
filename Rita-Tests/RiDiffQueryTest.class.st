Class {
	#name : #RiDiffQueryTest,
	#superclass : #IceAbstractTestCase,
	#category : #'Rita-Tests'
}

{ #category : #running }
RiDiffQueryTest >> newFixture [
	^ RiDiffQueryFixture inGit
]

{ #category : #tests }
RiDiffQueryTest >> test01ConsiderOnlyChangedButThereIsntAny [
	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit1 diffToParent;
		yourself.
	nodes := query nodesForBehaviors.
	self assert: nodes size equals: 1.
	nodes
		do: [ :each | 
			self assert: each value definition isClassDefinition.
			self assert: each value definition name equals: #A ]
]

{ #category : #tests }
RiDiffQueryTest >> test02ConsiderOnlyChangedThenItSkipsUnmodified [
	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit2 diffToParent;
		yourself.
	nodes := query nodesForBehaviors.
	self assert: nodes size equals: 1.
	nodes
		do: [ :each | 
			self assert: each value definition isClassDefinition.
			self assert: each value definition name equals: #B ]
]

{ #category : #tests }
RiDiffQueryTest >> test03ConsiderUnchangedWorks [
	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit2 diffToParent;
		onlyConsiderChanged: false;
		yourself.
	nodes := query nodesForBehaviors.
	self assert: nodes size equals: 2.
	nodes
		detect: [ :node | node value definition name = #A ]
		ifFound: [ :node | self deny: node value hasChanges ].
	nodes
		detect: [ :node | node value definition name = #B ]
		ifFound: [ :node | self assert: node value hasChanges ]
]

{ #category : #tests }
RiDiffQueryTest >> test04ConsiderUnchangedWithFileChanged [
	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit5 diffToParent;
		onlyConsiderChanged: false;
		yourself.
	nodes := query nodesForBehaviors.
	self assert: nodes size equals: 1.

]

{ #category : #tests }
RiDiffQueryTest >> test05ConsiderUnchangedWithAnotherPackage [

	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit6 diffToParent;
		onlyConsiderChanged: false;
		yourself.
	nodes := query nodesForBehaviors.
	self assert: nodes size equals: 2.

]

{ #category : #tests }
RiDiffQueryTest >> test06ConsiderOnlyChangedWithFiles [

	| query nodes |
	query := RiDiffQuery new
		diff: fixture commit7 diffToParent;
		onlyConsiderChanged: true;
		yourself.
	nodes := query nodesForFiles.
	self assert: nodes size equals: 3.

]
