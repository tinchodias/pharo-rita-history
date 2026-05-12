Class {
	#name : #RiPullRequestConversationItem,
	#superclass : #Object,
	#instVars : [
		'comments',
		'mapping',
		'pullRequest',
		'iceDiff'
	],
	#category : #'Rita-PullRequests-Model'
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

"	| repliedComment |
	repliedComment := comments
		detect: [ :c | c id = aPRComment repliedId ].
	comments add: aPRComment after: repliedComment"
	self assert: comments first id = aPRComment repliedId.
	comments addLast: aPRComment
]

{ #category : #accessing }
RiPullRequestConversationItem >> commentIdToReply [

	^ comments first id
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
	begin isOutdated ifTrue: [ ^ self "'outdated comment' traceCr" ].

	commitToResolve := begin isSideOfAddition
		ifTrue: [ iceDiff sourceVersion ]
		ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: begin path.
	lineNumber := begin line.

	mapping := (RiDiffMapping newForFileReference: file)
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
	self initializeMapping
]

{ #category : #accessing }
RiPullRequestConversationItem >> lineNumberInIceNodeDiff [
	"Answer the line number in the diff, that gathers inserted, removed and matched lines."

	| begin lineAndSideMapping |
	begin := comments first.
	lineAndSideMapping := mapping iceNode accept: ZuLineAndSideVisitor new.
	^ lineAndSideMapping indexOf: { mapping iceNodeLineNumber. begin side }
]

{ #category : #accessing }
RiPullRequestConversationItem >> mapping [

	^ mapping
]

{ #category : #accessing }
RiPullRequestConversationItem >> numberOfComments [

	^ comments size
]

{ #category : #accessing }
RiPullRequestConversationItem >> pullRequest [

	^ pullRequest
]
