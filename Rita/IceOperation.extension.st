Extension { #name : #IceOperation }

{ #category : #'*Rita' }
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

{ #category : #'*Rita' }
IceOperation >> ritaKey [
	^ self name
]
