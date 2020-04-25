"
I'm a personalized human-readable printer for Date.
"
Class {
	#name : #RiDatePrinter,
	#superclass : #Object,
	#instVars : [
		'extendedDatePrinter'
	],
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiDatePrinter >> initialize [
	super initialize.
	extendedDatePrinter := ExtendedDatePrinter new
]

{ #category : #printing }
RiDatePrinter >> printDate: aDate on: stream [
	extendedDatePrinter
		printDate: aDate
		format: #(1 2 3 $  2 2 1)
		on: stream
]

{ #category : #printing }
RiDatePrinter >> stringFor: aDate [
	^ String streamContents: [ :stream |
		self printDate: aDate on: stream ]
]
