Class {
	#name : #RiFTHackyAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'source'
	],
	#category : #'Rita-FastTable'
}

{ #category : #accessing }
RiFTHackyAnnouncement class >> source: anObject [
	^ self new
		initializeWithSource: anObject;
		yourself
]

{ #category : #testing }
RiFTHackyAnnouncement >> belongsToFastTable: aFTTableMorph [ 
	^ source dataSource table == aFTTableMorph
]

{ #category : #testing }
RiFTHackyAnnouncement >> belongsToSpTableTree: aSpTreeTablePresenter [
	^ aSpTreeTablePresenter isBuilt
		and: [ self belongsToFastTable: aSpTreeTablePresenter adapter widget ]
]

{ #category : #initialization }
RiFTHackyAnnouncement >> fastTableItem [
	^ source
]

{ #category : #initialization }
RiFTHackyAnnouncement >> initializeWithSource: anObject [
	self initialize.
	source := anObject
]
