Class {
	#name : #RiFTRootItem,
	#superclass : #FTRootItem,
	#category : #'Rita-FastTable'
}

{ #category : #enumerating }
RiFTRootItem >> allChildrenDo: aBlockClosure [
	self childrenDo: [ :each |
		aBlockClosure value: each.
		each allChildrenDo: aBlockClosure ]
]

{ #category : #enumerating }
RiFTRootItem >> childrenDo: aBlockClosure [
	self children do: aBlockClosure
]

{ #category : #accessing }
RiFTRootItem >> data: aCollection [
	self children: (aCollection collect: [ :object | RiFTBasicItem data: object from: dataSource ]) asArray
]
