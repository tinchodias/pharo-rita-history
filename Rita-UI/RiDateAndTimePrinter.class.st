"
I'm a personalized human-readable printer for Date.
"
Class {
	#name : #RiDateAndTimePrinter,
	#superclass : #Object,
	#instVars : [
		'datePrinter'
	],
	#category : #'Rita-UI-Support'
}

{ #category : #initialization }
RiDateAndTimePrinter >> initialize [
	super initialize.
	datePrinter := RiDatePrinter new.
]

{ #category : #printing }
RiDateAndTimePrinter >> stringFor: aDateAndTime [
	^ '{1}, {2}' format: {
		(datePrinter stringFor: aDateAndTime asDate).
		(self timeFor: aDateAndTime asTime)
		}
]

{ #category : #printing }
RiDateAndTimePrinter >> timeFor: aTime [
	^ aTime print24
]
