Class {
	#name : #RiActionAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'timestamp',
		'kind',
		'data'
	],
	#category : #'Rita-UI-Announcements'
}

{ #category : #converting }
RiActionAnnouncement >> asOrderedDictionary [
	"Convert to a dictionary which is convenient to be written as JSON."

	^ {
		#secondsSinceMidnight -> timestamp.
		#kind -> kind.
		#description -> data.
	} asOrderedDictionary

]

{ #category : #accessing }
RiActionAnnouncement >> currentTimestamp [
	"Number of seconds since midnight, as Float with decimals."

	^ DateAndTime now asDuration asMilliSeconds / 1000.0
]

{ #category : #accessing }
RiActionAnnouncement >> data [
	^ data
]

{ #category : #accessing }
RiActionAnnouncement >> data: anObject [
	data := anObject
]

{ #category : #accessing }
RiActionAnnouncement >> initialize [ 
	super initialize.
	
	timestamp := self currentTimestamp
]

{ #category : #accessing }
RiActionAnnouncement >> kind [
	^ kind
]

{ #category : #accessing }
RiActionAnnouncement >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
RiActionAnnouncement >> timestamp [
	^ timestamp
]

{ #category : #accessing }
RiActionAnnouncement >> timestamp: anObject [
	timestamp := anObject
]
