Class {
	#name : #RiNullAvatarClient,
	#superclass : #RiAbstractAvatarClient,
	#category : #'Rita-Avatars'
}

{ #category : #accessing }
RiNullAvatarClient >> avatarByEmailFuture [
	^ [ Dictionary empty ] future
]
