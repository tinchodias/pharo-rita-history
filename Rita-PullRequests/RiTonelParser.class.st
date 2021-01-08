"
I am a parser for Tonel files that, additionally to the behavior of my superclass, also records the file position (or line number) where the definitions begin andd end.
"
Class {
	#name : #RiTonelParser,
	#superclass : #TonelParser,
	#instVars : [
		'recordings',
		'string',
		'defRecordings'
	],
	#category : #'Rita-PullRequests-Model'
}

{ #category : #parsing }
RiTonelParser >> comment [
	^ self recordDuringSuperSend: #comment
]

{ #category : #parsing }
RiTonelParser >> currentLineNumber [
	^ string lineNumberCorrespondingToIndex: stream position
]

{ #category : #accessing }
RiTonelParser >> defRecordingAtLine: anInteger [ 
	^ defRecordings detect: [ :each | anInteger between: each second and: each third ]
]

{ #category : #accessing }
RiTonelParser >> defRecordings [
	^ defRecordings
]

{ #category : #accessing }
RiTonelParser >> definitionAtLine: anInteger [ 
	^ (self defRecordingAtLine: anInteger) fourth
]

{ #category : #initialization }
RiTonelParser >> initialize [
	super initialize.
	recordings := OrderedCollection new.
	defRecordings := OrderedCollection new.
]

{ #category : #parsing }
RiTonelParser >> metadata [
	^ self recordDuringSuperSend: #metadata
]

{ #category : #parsing }
RiTonelParser >> method [
	^ self recordDuringSuperSend: #method
]

{ #category : #parsing }
RiTonelParser >> methodBody [
	^ self recordDuringSuperSend: #methodBody
]

{ #category : #accessing }
RiTonelParser >> methodBodyOffsetAtLine: anInteger [
	"Answer the offset (in terms of number of lines) of the first line of the body to the specified integer."

	^ (self defRecordingAtLine: anInteger) second + 1
]

{ #category : #parsing }
RiTonelParser >> methodDef [
	^ self recordDefDuringSuperSend: #methodDef
]

{ #category : #parsing }
RiTonelParser >> recordDefDuringSuperSend: aSelector [
	| result startLine endLine |
	startLine := self currentLineNumber.
	result := self perform: aSelector withArguments: #() inSuperclass: TonelParser.
	endLine := self currentLineNumber.
	defRecordings add: { aSelector. startLine. endLine. result. }.
	^ result
]

{ #category : #parsing }
RiTonelParser >> recordDuringSuperSend: aSelector [
	| result startLine endLine |
	startLine := self currentLineNumber.
	result := self perform: aSelector withArguments: #() inSuperclass: TonelParser.
	endLine := self currentLineNumber.
	recordings add: { aSelector. startLine. endLine. result. }.
	^ result
]

{ #category : #accessing }
RiTonelParser >> recordingAtLine: anInteger [ 
	^ recordings detect: [ :each | anInteger between: each second and: each third ]
]

{ #category : #accessing }
RiTonelParser >> recordings [
	^ recordings
]

{ #category : #accessing }
RiTonelParser >> string: aString [
	string := aString
]

{ #category : #parsing }
RiTonelParser >> typeDef [
	^ self recordDefDuringSuperSend: #typeDef
]
