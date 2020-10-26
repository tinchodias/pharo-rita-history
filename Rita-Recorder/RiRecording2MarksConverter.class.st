"
I convert the recording outputed by RiSessionRecorder into a [Youtube-notes](https://github.com/tinchodias/youtube-notes) marks.

## Example

```
RiRecording2MarksConverter new
	inputFileReference: 'recording-392174336.json' asFileReference;
	firstMarkInVideoPlayback: 22.04 seconds;
	convert.

```
"
Class {
	#name : #RiRecording2MarksConverter,
	#superclass : #Object,
	#instVars : [
		'outputFileReference',
		'firstMarkInVideoPlayback',
		'inputFileReference'
	],
	#category : #'Rita-Recorder'
}

{ #category : #converting }
RiRecording2MarksConverter >> convert [

	| entries output offset |
	entries := self inputFileReference
		readStreamDo: [ :stream | STONJSON fromStream: stream ].

	offset := (entries first at: 'secondsSinceMidnight') -
		(self firstMarkInVideoPlayback asMilliSeconds / 1000.0).

	output := entries collect: [ :each |
		{	'timestamp' -> ((each at: 'secondsSinceMidnight') - offset).
			'description' -> ((each at: 'kind'), ': ', (each at: 'description')).
			'tagId' -> 'action'.
		} asOrderedDictionary ].

	self outputFileReference
		ensureDelete
		writeStreamDo: [ :stream |
			STONJSON put: output onStreamPretty: stream ].

]

{ #category : #accessing }
RiRecording2MarksConverter >> firstMarkInVideoPlayback [
	^ firstMarkInVideoPlayback
]

{ #category : #accessing }
RiRecording2MarksConverter >> firstMarkInVideoPlayback: aDuration [
	firstMarkInVideoPlayback := aDuration
]

{ #category : #accessing }
RiRecording2MarksConverter >> inputFileReference [
	^ inputFileReference
]

{ #category : #accessing }
RiRecording2MarksConverter >> inputFileReference: aFileReference [
	inputFileReference := aFileReference

]

{ #category : #accessing }
RiRecording2MarksConverter >> outputFileReference [
	^ outputFileReference ifNil: [
		outputFileReference := inputFileReference parent /
			inputFileReference basenameWithoutExtension, 'marks.json' ]
]

{ #category : #accessing }
RiRecording2MarksConverter >> outputFileReference: aFileReference [
	outputFileReference := aFileReference
]
