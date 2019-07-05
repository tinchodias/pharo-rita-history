Extension { #name : #IceTipCommitModel }

{ #category : #'*Rita-IceTip' }
IceTipCommitModel >> descriptionWithDecoration [
	| text |
	text := (', ' join: self entity tagNames) asText allBold makeAllColor: Color gray.
	text ifNotEmpty: [ text := text , ' ' ].
	text append: (self entity comment withLineEndings: ' ') asText.
	^ text
]
