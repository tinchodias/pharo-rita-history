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
		'writeDeferrer',
		'alreadyWritten'
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
		alreadyWritten ifFalse: [
			stream << ',
' ].
	alreadyWritten := false.
		STONJSON put: each asOrderedDictionary onStreamPretty: stream ].
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

	alreadyWritten := true.
	fileReference := ('recording-<1p>.json ' expandMacrosWith: self identityHash) asFileReference.

]

{ #category : #convenience }
RiSessionRecorder >> openInOSFileBrowser [
	fileReference openInOSFileBrowser
]

{ #category : #accessing }
RiSessionRecorder >> rootModel [
	"Answer the model of the Rita window (assuming it's open)."

	^ window presenter model
]

{ #category : #API }
RiSessionRecorder >> start [

	window := RiRootPresenter open.

	stream := fileReference writeStream.
	stream nextPutAll: '[
'.

	self rootModel actionsAnnouncer weak
		when: RiBasicActionAnnouncement send: #add: to: self.

	self add: (RiBasicActionAnnouncement new
			 kind: #recording;
			 data: 'start';
			 yourself).
	
	self inform: ('Started to record actions on <1p>.' expandMacrosWith: fileReference pathString)
]

{ #category : #API }
RiSessionRecorder >> stop [

	self add: (RiBasicActionAnnouncement new
			 kind: #recording;
			 data: 'stop';
			 yourself).

	self flushPendingToWrite.	

	stream << '
]'.

	self inform: ('Finished to record actions on <1p>.' expandMacrosWith: fileReference pathString).

	stream close.
]

{ #category : #accessing }
RiSessionRecorder >> window [
	"Answer the Rita window (assuming it was open via #start)."

	^ window
]
