Class {
	#name : #RiAbstractAvatarClient,
	#superclass : #Object,
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiAbstractAvatarClient >> avatarByEmail [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiAbstractAvatarClient >> process [
	self subclassResponsibility
]
