Class {
	#name : #RiPullRequestConversationItem,
	#superclass : #Object,
	#instVars : [
		'comments',
		'mapping',
		'pullRequest',
		'iceDiff'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #'instance creation' }
RiPullRequestConversationItem class >> withComment: aComment pullRequest: aPullRequest iceDiff: anIceDiff [
	^ self basicNew
		initializeWithComment: aComment
			pullRequest: aPullRequest
			iceDiff: anIceDiff;
		yourself
]

{ #category : #accessing }
RiPullRequestConversationItem >> addReply: aPRComment [
	| repliedComment |
	repliedComment := comments
		detect: [ :c | c id = aPRComment repliedId ].
	comments add: aPRComment after: repliedComment
]

{ #category : #accessing }
RiPullRequestConversationItem >> comments [
	^ comments
]

{ #category : #testing }
RiPullRequestConversationItem >> hasMapping [
	^ mapping isNotNil
]

{ #category : #testing }
RiPullRequestConversationItem >> includesCommentWithId: anInteger [ 
	^ comments anySatisfy: [ :each | each id = anInteger ]
]

{ #category : #initialization }
RiPullRequestConversationItem >> initializeMapping [

	| begin commitToResolve file lineNumber |
	begin := comments first.
	begin isHunkComment ifFalse: [ ^ self ].

	commitToResolve := begin isSideOfAddition
		ifTrue: [ iceDiff sourceVersion ]
		ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: begin path.
	lineNumber := begin originalLine. "line ?"

	mapping := (file extension = 'st'
		ifTrue: [ RiTonelToDiffMapping new ] 
		ifFalse: [ RiFileToDiffMapping new ])
			file: file;
			lineNumber: lineNumber;
			iceDiff: iceDiff; 
			calculate;
			yourself
]

{ #category : #initialization }
RiPullRequestConversationItem >> initializeWithComment: aComment pullRequest: aPullRequest iceDiff: anIceDiff [
	self initialize.
	comments := OrderedCollection with: aComment.
	pullRequest := aPullRequest.
	iceDiff := anIceDiff.
	self initializeMapping.
]

{ #category : #accessing }
RiPullRequestConversationItem >> mapping [
	^ mapping
]
