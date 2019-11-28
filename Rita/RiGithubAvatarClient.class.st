Class {
	#name : #RiGithubAvatarClient,
	#superclass : #Object,
	#instVars : [
		'remote',
		'credentials',
		'avatarSize',
		'commitsIds',
		'avatarUrlByEmail',
		'avatarByEmail'
	],
	#category : #'Rita-Avatars'
}

{ #category : #'accessing - response' }
RiGithubAvatarClient >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #private }
RiGithubAvatarClient >> avatarFor: urlString [

	| form |
	form := ZnEasy getImage: urlString, '&s=', self avatarSize asString.
	
	"We found some cases where responded image doesn't have the requested size."
	^ form scaledToSize: self avatarSize asPoint.
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> avatarSize [
	^ avatarSize
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> avatarSize: anObject [
	avatarSize := anObject
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> commitsIds [
	^ commitsIds
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> commitsIds: anObject [
	commitsIds := anObject
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> credentials [
	^ credentials
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> credentials: anObject [
	credentials := anObject
]

{ #category : #action }
RiGithubAvatarClient >> get [
	"Do the HTTP requests"

	self getAvatarUrlByEmail.
	self getAvatarByEmail.
]

{ #category : #private }
RiGithubAvatarClient >> getAvatarByEmail [
	"HTTP GET avatar images in parallel"

	| sharedQueue semaphore |
	sharedQueue := SharedQueue new.
	semaphore := Semaphore new.

	avatarUrlByEmail keysAndValuesDo: [ :email :urlString |
		[[ | avatar |
		avatar := self avatarFor: urlString.
		sharedQueue	nextPut: (email -> avatar) ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | ].
		semaphore signal.
		] fork ].
	avatarUrlByEmail size timesRepeat: [ semaphore wait ].

	avatarByEmail := sharedQueue contents asDictionary

]

{ #category : #action }
RiGithubAvatarClient >> getAvatarUrlByEmail [
	"Get all avatar URLs via Github API v4."

	| response |
	"Query Github"
	response := IceGitHubAPI new
		credentials: self credentials;
		graphql: self graphQL.

	"On sucess: Get avatar URLs"
	avatarUrlByEmail := Dictionary new.
	((response at: 'data') at: 'repository') valuesDo: [ :each |
		self registerAvatarUrlByEmail: (each at: 'author').
		self registerAvatarUrlByEmail: (each at: 'committer') ].

]

{ #category : #private }
RiGithubAvatarClient >> graphQL [
	^ String streamContents: [ :stream |
		stream << '{ repository(owner: "' << remote owner << '", name: "' << remote projectName << '") {'.
		commitsIds doWithIndex: [ :id :index |
			stream << 'u' << index asString << ' : object(oid: "' << id << '") { ...authorFragment } ' ].
		stream << '} }
fragment authorFragment on GitObject {
  ... on Commit {
    author {
      email
      avatarUrl
    }
    committer {
      email
      avatarUrl
    }
  }
}
' ].
]

{ #category : #action }
RiGithubAvatarClient >> registerAvatarUrlByEmail: aDictionary [
	avatarUrlByEmail
		at: (aDictionary at: 'email')
		ifAbsentPut: [ aDictionary at: 'avatarUrl' ]
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> remote [
	^ remote
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> remote: anIceRemote [
	remote := anIceRemote
]
