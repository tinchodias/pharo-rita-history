Class {
	#name : #HiMCollapse,
	#superclass : #HiMNodeCommand,
	#category : #'Rita-Navigator-UI-Commands'
}

{ #category : #execution }
HiMCollapse >> execute [
	navigator collapse: node
]

{ #category : #execution }
HiMCollapse >> inverse [
	^ HiMExpand new
		navigator: navigator;
		node: node;
		yourself
]
