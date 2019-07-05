Class {
	#name : #HiMExpand,
	#superclass : #HiMNodeCommand,
	#category : #'Rita-Navigator'
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
