"
I record a session of Rita browser.

## Usage example:


""To begin""
aRecorder := RiSessionRecorder new.
aRecorder start.

""To finish""
aRecorder stop.

""Inspect the .json file output""
aRecorder fileReference inspect.
"
Class {
	#name : #RiSessionRecorder,
	#superclass : #Object,
	#instVars : [
		'window',
		'pendingToWrite',
		'fileReference',
		'stream',
		'writeDeferrer'
	],
	#category : #'Rita-Recorder'
}

{ #category : #'handling actions' }
RiSessionRecorder >> add: aRiUserActionAnnouncement [ 

	pendingToWrite nextPut: aRiUserActionAnnouncement.
	writeDeferrer schedule.
]

{ #category : #accessing }
RiSessionRecorder >> fileReference [
	^ fileReference
]

{ #category : #accessing }
RiSessionRecorder >> fileReference: aFileReference [
	fileReference := aFileReference
]

{ #category : #writing }
RiSessionRecorder >> flushPendingToWrite [

	pendingToWrite flush: [ :each |
		STONJSON put: each asOrderedDictionary onStreamPretty: stream.
		stream << ',
' ].
	stream flush.
]

{ #category : #API }
RiSessionRecorder >> initialize [
	super initialize.
	
	pendingToWrite := AtomicSharedQueue new.
	writeDeferrer := OmDeferrer 
		send: #flushPendingToWrite
		to: self
		after: 250 milliSeconds.

	fileReference := ('recording-<1p>.json ' expandMacrosWith: self identityHash) asFileReference.

]

{ #category : #API }
RiSessionRecorder >> start [

	| rootModel |
	window := RiRootPresenter open.
	rootModel := window presenter model.

	stream := fileReference writeStream.
	
	stream nextPutAll: '[
'.

	rootModel actionsAnnouncer weak
		when: RiActionAnnouncement send: #add: to: self.
	
	self inform: ('Started to record actions on <1p>.' expandMacrosWith: fileReference pathString)
]

{ #category : #API }
RiSessionRecorder >> stop [

	stream << '
]'.

	self inform: ('Finished to record actions on <1p>.' expandMacrosWith: fileReference pathString).

	stream close.
]
