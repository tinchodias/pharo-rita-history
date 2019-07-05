"
Abstract DataSource. My subclasses demonstrate how to show avatars in Iceberg repositories view.
"
Class {
	#name : #RiIceTipAvatarsDataSource,
	#superclass : #RiIceTipDataSource,
	#instVars : [
		'avatarByEmail'
	],
	#category : #'Rita-IceTip'
}

{ #category : #accessing }
RiIceTipAvatarsDataSource >> avatarFor: commitId [
	^ avatarByEmail
		at: (commitById at: commitId) authorEmail
		ifAbsent: [ self iconNamed: #user ]
]

{ #category : #accessing }
RiIceTipAvatarsDataSource >> avatarSize [
	^ self subclassResponsibility
]

{ #category : #private }
RiIceTipAvatarsDataSource >> freshAvatarsByEmail [
	"Answer a Dictionary<String,Form> for the authors of all commits. It gets the avatars using internet, and answer an empty dictionary when HTTP connections weren't successful."

	| githubRemote commitsByEmail commitsIdsToQuery credentials client |
	elements ifEmpty: [ ^ Dictionary new ].
	githubRemote := (elements first repositoryModel remotes
		select: [ :each | each host = 'github.com' ])
			ifEmpty: [ Dictionary new ]
			ifNotEmpty: #anyOne.
	
	commitsByEmail := elements groupedBy: [ :each | each entity authorEmail ].
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

{ #category : #private }
RiIceTipAvatarsDataSource >> refreshRulerWithCurrentElements [
	super refreshRulerWithCurrentElements.
	
	avatarByEmail := self freshAvatarsByEmail.
]
