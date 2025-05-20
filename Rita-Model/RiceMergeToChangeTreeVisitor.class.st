"
I visit a tree of IceNode with IceOperationMerge with all operations already chosen and return the coresponding tree of changes (IceNodes with IceOperation)
"
Class {
	#name : 'RiceMergeToChangeTreeVisitor',
	#superclass : 'RiceTreeVisitor',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'as yet unclassified' }
RiceMergeToChangeTreeVisitor >> convertMergeNodeToChangeNode [
	currentNode value: currentNode value chosenOperation .
]

{ #category : 'visiting' }
RiceMergeToChangeTreeVisitor >> visitAddition: anIceAddition [ 
	self convertMergeNodeToChangeNode.
]

{ #category : 'visiting' }
RiceMergeToChangeTreeVisitor >> visitClassDefinition: anIceClassDefinition [ 
	self convertMergeNodeToChangeNode.
	self visitChildrenOf: currentNode
]

{ #category : 'visting' }
RiceMergeToChangeTreeVisitor >> visitNoModification: anIceNoModification [
	anIceNoModification definition accept: self.
]

{ #category : 'visting' }
RiceMergeToChangeTreeVisitor >> visitNonConflictingOperation: anIceNonConflictingOperation [ 
	anIceNonConflictingOperation chosenOperation accept: self.
]

{ #category : 'visiting' }
RiceMergeToChangeTreeVisitor >> visitPackage: anIcePackageDefinition [
	self convertMergeNodeToChangeNode.
	self visitChildrenOf: currentNode
]

{ #category : 'visting' }
RiceMergeToChangeTreeVisitor >> visitRootDefinition: anIceRootDefinition [ 
	self visitChildrenOf: currentNode
]
