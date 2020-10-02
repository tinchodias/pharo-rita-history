"
I provide avatars for the authors and committers of the commits of a repository.

My main collaborator is a Dictionary<String,Form> that caches the avatars.

"
Class {
	#name : #RiAvatarsDatabase,
	#superclass : #Object,
	#instVars : [
		'avatarByEmail',
		'riRepository',
		'avatarSize',
		'mockAvatar'
	],
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiAvatarsDatabase >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarFor: emailString [
	^ avatarByEmail
		at: emailString
		ifAbsent: [ self mockAvatar ]
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarSize [
	^ avatarSize
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarSize: anInteger [
	"Set the desired size for the next retrieved avatars."

	avatarSize := anInteger.
	self buildMockAvatar.
]

{ #category : #accessing }
RiAvatarsDatabase >> buildMockAvatar [

"	mockAvatar := self iconNamed: #user"
	mockAvatar := RiIconGenerator new
		extent: avatarSize asPoint;
		addBordered: RSShapeFactory circle
			color: Color gray;
		addLabel: '?'
			color: Color gray;
		newForm

]

{ #category : #accessing }
RiAvatarsDatabase >> initialize [
	super initialize.

	self avatarSize: 16.
	avatarByEmail := Dictionary new.

]

{ #category : #accessing }
RiAvatarsDatabase >> mockAvatar [
	^ mockAvatar
]

{ #category : #accessing }
RiAvatarsDatabase >> mockAvatar: aForm [
	mockAvatar := aForm
]

{ #category : #private }
RiAvatarsDatabase >> newAvatarClient [

	riRepository iceRepository remotes
		detect: [ :each | each host = 'github.com' ]
		ifFound: [ :found | ^ self newGithubAvatarClientFor: found ].

	riRepository iceRepository remotes
		detect: [ :each | each host = 'gitlab.com' ]
		ifFound: [ :found | ^ self newGitlabAvatarClientFor: found ].
	
	^ self newNullAvatarClient
]

{ #category : #private }
RiAvatarsDatabase >> newGithubAvatarClientFor: githubRemote [ 

	| commits commitsByEmail credentials |
	commits := riRepository commits.
	commits ifEmpty: [ ^ self newNullAvatarClient ].

	commitsByEmail := Dictionary new.
	commits do: [:each |
		commitsByEmail
			at: each authorEmail ifAbsentPut: [ each id ];
			at: each committerEmail ifAbsentPut: [ each id ] ].
	
	self flag: #todo.
	[ credentials := IceGitHubAPI ensureCredentials"; obtainCredentials" ]
		on: LGitNoCredentialsProvided do: [ "ignore" ].

	^ RiGithubAvatarClient new
		remote: githubRemote;
		credentials: credentials;
		avatarSize: self avatarSize;
		commitsIds: commitsByEmail values;
		yourself
]

{ #category : #private }
RiAvatarsDatabase >> newGitlabAvatarClientFor: aRemote [ 

	| commits emails |
	commits := riRepository commits.
	commits ifEmpty: [ ^ self newNullAvatarClient ].

	emails := Array streamContents: [ :stream |
		commits do: [:each | 
			stream
				nextPut: each authorEmail;
				nextPut: each committerEmail ]].

	^ RiGitlabAvatarClient new
		emails: emails asSet;
		avatarSize: self avatarSize;
		yourself
]

{ #category : #private }
RiAvatarsDatabase >> newNullAvatarClient [
	^ RiNullAvatarClient new
]

{ #category : #refreshing }
RiAvatarsDatabase >> process [
	| client |
	client := self newAvatarClient.
	client process.
	avatarByEmail := client avatarByEmail.
]

{ #category : #accessing }
RiAvatarsDatabase >> riRepository: aRiRepository [
	riRepository := aRiRepository

]
