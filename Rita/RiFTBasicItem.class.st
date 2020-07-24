Class {
	#name : #RiFTBasicItem,
	#superclass : #FTBasicItem,
	#classInstVars : [
		'hackyAnnouncer'
	],
	#category : #'Rita-FastTable'
}

{ #category : #accessing }
RiFTBasicItem class >> hackyAnnouncer [
	^ hackyAnnouncer ifNil: [ hackyAnnouncer := Announcer new ]
]

{ #category : #enumerating }
RiFTBasicItem >> allChildrenDo: aBlockClosure [
	self childrenDo: [ :each |
		aBlockClosure value: each.
		each allChildrenDo: aBlockClosure ]
]

{ #category : #enumerating }
RiFTBasicItem >> childrenDo: aBlockClosure [
	self children do: aBlockClosure
]

{ #category : #'expanding-collapsing' }
RiFTBasicItem >> collapse [
	self class hackyAnnouncer announce: (RiFTHackyCollapse source: self).
	^ super collapse
]

{ #category : #'expanding-collapsing' }
RiFTBasicItem >> expand [
	self class hackyAnnouncer announce: (RiFTHackyExpand source: self).
	^ super expand
]
