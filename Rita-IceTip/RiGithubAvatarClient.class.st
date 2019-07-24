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
	#category : #'Rita-IceTip-HiedraCommits'
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

{ #category : #'accessing - response' }
RiGithubAvatarClient >> avatarUrlByEmail [
	^ avatarUrlByEmail
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

	| response |

	"Query Github"
	
	([	response := IceGitHubAPI new
		credentials: self credentials;
		graphql: self graphQL.
	] timeToRun asMilliSeconds asString, ' - to query github') logCr.

	"On sucess: Get avatar URLs"
	avatarUrlByEmail := Dictionary new.
	((response at: 'data') at: 'repository') values
		collect: [:each | each at: 'author' ]
		thenDo: [:each |
			avatarUrlByEmail
				at: (each at: 'email')
				put: (each at: 'avatarUrl') ].

	self flag: #todo. "On fail!?"

	"Get avatar images"
	([self getAvatarsAsync] timeToRun asMilliSeconds asString, ' - to get ALL avatars') logCr.

]

{ #category : #private }
RiGithubAvatarClient >> getAvatarsAsync [

	| sharedQueue semaphore |
	sharedQueue := SharedQueue new.
	semaphore := Semaphore new.

	avatarUrlByEmail keysAndValuesDo: [ :email :urlString |
		[
		
		[ | avatar |
		avatar := self avatarFor: urlString.
		sharedQueue	nextPut: (email -> avatar) ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | ].
		semaphore signal.
		] fork ].
	avatarUrlByEmail size timesRepeat: [ semaphore wait ].

	avatarByEmail := Dictionary new.
	sharedQueue contents do: [ :association |
		avatarByEmail at: association key put: association value ].

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
  }
}
' ].
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> remote [
	^ remote
]

{ #category : #'accessing - request' }
RiGithubAvatarClient >> remote: anObject [
	remote := anObject
]
