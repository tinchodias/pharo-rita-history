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
RiTonelParser >> currentPosition [
	^ string lineNumberCorrespondingToIndex: stream position. "{
		stream position.
		string lineNumberCorrespondingToIndex: stream position.
	}"
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
	^ (self defRecordingAtLine: anInteger) second + 2
]

{ #category : #parsing }
RiTonelParser >> methodDef [
	^ self recordDefDuringSuperSend: #methodDef
]

{ #category : #parsing }
RiTonelParser >> recordDefDuringSuperSend: aSelector [
	| result start end |
	start := self currentPosition.
	result := self perform: aSelector withArguments: #() inSuperclass: TonelParser.
	end := self currentPosition.
	defRecordings add: { aSelector. start. end. result. }.
	^ result
]

{ #category : #parsing }
RiTonelParser >> recordDuringSuperSend: aSelector [
	| result start end |
	start := self currentPosition.
	result := self perform: aSelector withArguments: #() inSuperclass: TonelParser.
	end := self currentPosition.
	recordings add: { aSelector. start. end. result. }.
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
