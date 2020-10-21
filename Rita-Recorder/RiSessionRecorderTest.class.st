"
A RiSessionRecorderTest is a test class for testing the behavior of RiSessionRecorder
"
Class {
	#name : #RiSessionRecorderTest,
	#superclass : #TestCase,
	#category : #'Rita-Recorder'
}

{ #category : #tests }
RiSessionRecorderTest >> testParseRecording [
	| recorder contents |
	recorder := RiSessionRecorder new.
	recorder start.
	50 milliSeconds wait.
	recorder stop.
	500 milliSeconds wait.
	
	self assert: recorder window notNil.
	recorder window close.
	
	recorder fileReference readStreamDo: [ :stream |
		contents := STONJSON fromStream: stream.
	].

	self assert: contents size equals: 2.
]
