Class {
	#name : #RiGitlabAvatarClient,
	#superclass : #RiAbstractAvatarClient,
	#instVars : [
		'emails',
		'avatarSize',
		'avatarByEmail'
	],
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiGitlabAvatarClient >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #accessing }
RiGitlabAvatarClient >> avatarSize [
	^ avatarSize
]

{ #category : #accessing }
RiGitlabAvatarClient >> avatarSize: anObject [
	avatarSize := anObject
]

{ #category : #accessing }
RiGitlabAvatarClient >> emails: anObject [
	emails := anObject
]

{ #category : #private }
RiGitlabAvatarClient >> getAvatarForm: email [

	| url form |
	url := 'https://gitlab.com/api/v4/avatar?email={1}&size={2}' format: { email. self avatarSize }.
	url := (STONJSON fromString: (ZnEasy get: url) entity string) at: 'avatar_url'.
	form := ZnEasy getImage: url.

	"The responded image doesn't always (or never?) have the requested size."
	^ form scaledToSize: self avatarSize asPoint.
]

{ #category : #accessing }
RiGitlabAvatarClient >> process [
	"HTTP GET avatar images in parallel"

	| sharedQueue semaphore |
	sharedQueue := SharedQueue new.
	semaphore := Semaphore new.

	emails do: [ :email |
		[[ | avatar |
		avatar := self getAvatarForm: email.
		sharedQueue	nextPut: (email -> avatar) ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | ].
		semaphore signal.
		] fork ].
	emails size timesRepeat: [ semaphore wait ].

	avatarByEmail := sharedQueue contents asDictionary

]
