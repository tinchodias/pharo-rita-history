Extension { #name : #RiceOperation }

{ #category : #'*Rita-UI' }
RiceOperation >> newUnifiedStringDiff [
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
RiceOperation >> ritaKey [
	^ self name
]
