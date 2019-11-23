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
RiAvatarsDatabase >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarFor: aRiElement [
	^ avatarByEmail
		at: aRiElement authorEmail
		ifAbsent: [ self iconNamed: #user ]
]

{ #category : #accessing }
RiAvatarsDatabase >> avatarSize [
	^ 16
]

{ #category : #private }
RiAvatarsDatabase >> freshAvatarsByEmail [
	"Answer a Dictionary<String,Form> ')' expected -> for the authors of all commits. It gets the avatars using internet, and answer an empty dictionary when HTTP connections weren't successful."

	| commits githubRemote commitsByEmail commitsIdsToQuery credentials client |
	commits := riRepository elements reject: #isUncommited.
	commits ifEmpty: [ ^ Dictionary new ].
	githubRemote := (riRepository iceRepository remotes
		select: [ :each | each host = 'github.com' ])
			ifEmpty: [ Dictionary new ]
			ifNotEmpty: #anyOne.
	
	commitsByEmail := commits groupedBy: #authorEmail.
	commitsIdsToQuery := commitsByEmail values collect: [:each | each last id ].
	
	credentials := IceGitHubAPI ensureCredentials; obtainCredentials.

	client := RiGithubAvatarClient new
		remote: githubRemote;
		credentials: credentials;
		avatarSize: self avatarSize;
		commitsIds: commitsIdsToQuery;
		yourself.

	^ [ client get.
		client avatarByEmail ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | Dictionary new ].

]

{ #category : #refreshing }
RiAvatarsDatabase >> refreshWith: aRiRepository [ 
	riRepository := aRiRepository.
	avatarByEmail := self freshAvatarsByEmail.
]
