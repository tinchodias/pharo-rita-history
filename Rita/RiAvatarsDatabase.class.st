"
I provide avatars for the authors and committers of the commits of a repository.

My main collaborator is a Dictionary<String,Form> that caches the avatars.

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

	| commits commitsByEmail commitsIdsToQuery credentials |
	commits := riRepository elements reject: #isUncommited.
	commits ifEmpty: [ ^ self newNullAvatarClient ].

	self flag: #todo. "Consider commiters too!"
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
RiAvatarsDatabase >> refreshWith: aRiRepositoryPresenter [
	riRepository := aRiRepositoryPresenter riRepository.

	avatarByEmail := Dictionary new.
	self newAvatarClient avatarByEmailFuture
		onSuccessDo: [ :result | avatarByEmail := result.
			aRiRepositoryPresenter refreshOnAvatarsUpdate ]
]

{ #category : #accessing }
RiAvatarsDatabase >> timeout [
	^ 10 seconds
]
