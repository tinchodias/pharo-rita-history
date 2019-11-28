Class {
	#name : #RiAbstractAvatarClient,
	#superclass : #Object,
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiAbstractAvatarClient >> avatarByEmailFuture [
	^ self subclassResponsibility
]
