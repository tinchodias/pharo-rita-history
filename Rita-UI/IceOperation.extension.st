Extension { #name : #IceOperation }

{ #category : #'*Rita-UI' }
IceOperation >> newUnifiedStringDiff [
	| right left |
	right := self rightContents.
	left := self leftContents.
	(right size + left size) > 20000
		ifTrue: [ left := right := 'Too large to compare' ].
		
	^ RiUnifiedStringDiff new
		oldString: right;
		newString: left;
		build;
		yourself.

]

{ #category : #'*Rita-UI' }
IceOperation >> ritaKey [
	^ self name
]
