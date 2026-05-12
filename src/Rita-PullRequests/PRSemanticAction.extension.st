Extension { #name : #PRSemanticAction }

{ #category : #'*Rita-PullRequests' }
PRSemanticAction >> getClassOrNil [

	"It was failing with https://github.com/ObjectProfile/Roassal3/pull/273"

	self class environment 
			at: tokens first asString asSymbol  
			ifPresent: [ :cl | entity := cl ]
			ifAbsent: [ ].
	^ entity
				
]
