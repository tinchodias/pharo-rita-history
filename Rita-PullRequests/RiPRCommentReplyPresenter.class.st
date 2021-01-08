Class {
	#name : #RiPRCommentReplyPresenter,
	#superclass : #RiPresenter,
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPRCommentReplyPresenter class >> defaultSpec [

	^ SpPanedLayout newVertical
		  add: #notebook;
		  yourself
]
