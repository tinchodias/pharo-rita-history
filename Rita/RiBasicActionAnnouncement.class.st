Class {
	#name : #RiBasicActionAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'timestamp',
		'kind',
		'data'
	],
	#category : #'Rita-UI-Announcements'
}

{ #category : #converting }
RiBasicActionAnnouncement >> asOrderedDictionary [
	"Convert to a dictionary which is convenient to be written as JSON."

	^ {
		#secondsSinceMidnight -> timestamp.
		#kind -> kind.
		#description -> data.
	} asOrderedDictionary

]

{ #category : #accessing }
RiBasicActionAnnouncement >> currentTimestamp [
	"Number of seconds since midnight, as Float with decimals."

	^ DateAndTime now asDuration asMilliSeconds / 1000.0
]

{ #category : #accessing }
RiBasicActionAnnouncement >> data [
	^ data
]

{ #category : #accessing }
RiBasicActionAnnouncement >> data: anObject [
	data := anObject
]

{ #category : #accessing }
RiBasicActionAnnouncement >> initialize [ 
	super initialize.
	
	timestamp := self currentTimestamp
]

{ #category : #accessing }
RiBasicActionAnnouncement >> kind [
	^ kind
]

{ #category : #accessing }
RiBasicActionAnnouncement >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
RiBasicActionAnnouncement >> timestamp [
	^ timestamp
]

{ #category : #accessing }
RiBasicActionAnnouncement >> timestamp: anObject [
	timestamp := anObject
]
