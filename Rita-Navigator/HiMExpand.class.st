Class {
	#name : #HiMExpand,
	#superclass : #HiMNodeCommand,
	#category : #'Rita-Navigator-UI-Commands'
}

{ #category : #execution }
HiMExpand >> execute [
	navigator expand: node
]

{ #category : #execution }
HiMExpand >> inverse [
	^ HiMCollapse new
		navigator: navigator;
		node: node;
		yourself
]
