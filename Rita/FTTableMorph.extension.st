Extension { #name : #FTTableMorph }

{ #category : #'*Rita' }
FTTableMorph >> beRitaContainer [
	| oldContainer |
	oldContainer := container.
	container := RiFTTableContainer new.
	self replaceSubmorph: oldContainer by: container.
	self resizeAllSubviews
]
