"
I'm a FastTable data source that demonstrates how to show avatars in the author column of Iceberg repositories view.

"
Class {
	#name : #RiAvatarsDatabase,
	#superclass : #Object,
	#instVars : [
		'avatarByEmail',
		'riRepository'
	],
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiAvatarsDatabase >> avatarFor: emailString [
	^ avatarByEmail
		at: emailString
		ifAbsent: [ self iconNamed: #user ]
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarSize [
	^ 16
]

{ #category : #private }
RiAvatarsDatabase >> freshAvatarsByEmail [
	"Answer a Dictionary<String,Form> ')' expected -> for the authors of all commits. It gets the avatars using internet, and answer an empty dictionary when HTTP connections weren't successful."

	^ [ self newAvatarClient avatarByEmailFuture
		synchronizeTimeout: self timeout ]
		on: TKTTimeoutException
		do: [ :e | Dictionary empty ]
]

{ #category : #refreshing }
RiAvatarsDatabase >> initialize [
	super initialize.
	
	avatarByEmail := Dictionary new.
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

	| commits commitsByEmail commitsIdsToQuery credentials client |
	commits := riRepository elements reject: #isUncommited.
	commits ifEmpty: [ ^ self newNullAvatarClient ].

	commitsByEmail := commits groupedBy: #authorEmail.

	commitsIdsToQuery := commitsByEmail values collect: [:each | each last id ].
	
	credentials := IceGitHubAPI "ensureCredentials; "obtainCredentials.

	^ RiGithubAvatarClient new
		remote: githubRemote;
		credentials: credentials;
		avatarSize: self avatarSize;
		commitsIds: commitsIdsToQuery;
		yourself
]

{ #category : #private }
RiAvatarsDatabase >> newGitlabAvatarClientFor: aRemote [ 

	| commits emails |
	commits := riRepository elements reject: #isUncommited.
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
RiAvatarsDatabase >> refreshWith: aRiRepository [ 
	riRepository := aRiRepository.
	avatarByEmail := self freshAvatarsByEmail.
]

{ #category : #accessing }
RiAvatarsDatabase >> timeout [
	^ 10 seconds
]
