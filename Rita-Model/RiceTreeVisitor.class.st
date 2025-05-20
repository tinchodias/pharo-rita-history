"
I implement a basic tree visitor for Iceberg trees implemented through IceNode
"
Class {
	#name : 'RiceTreeVisitor',
	#superclass : 'Object',
	#instVars : [
		'currentNode'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceTreeVisitor >> visitChildrenOf: anIceNode [ 
	
	anIceNode childrenDo: [ :each | each accept: self ]
]

{ #category : 'visiting' }
RiceTreeVisitor >> visitConflictingOperation: anIceConflictingOperation [ 
	
	anIceConflictingOperation isResolved
		ifFalse: [ self error: 'Cannot apply a non resolved conflict' ].
		
	^ anIceConflictingOperation chosenOperation accept: self
]

{ #category : 'visiting' }
RiceTreeVisitor >> visitEmptyNode: anIceEmptyNode [ 
	
	"Do nothing by default"
]

{ #category : 'visiting' }
RiceTreeVisitor >> visitTreeNode: anIceNode [
	
	self withNode: anIceNode do: [ 
		^ anIceNode value accept: self ]
]

{ #category : 'visiting' }
RiceTreeVisitor >> withNode: anIceNode do: aBlockClosure [ 
	
	| previousNode |
	previousNode := currentNode.
	currentNode := anIceNode.
	aBlockClosure ensure: [ 
		currentNode := previousNode ]
]
