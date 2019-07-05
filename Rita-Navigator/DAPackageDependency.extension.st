Extension { #name : #DAPackageDependency }

{ #category : #'*Rita-Navigator' }
DAPackageDependency >> accept: aVisitor [
	^ aVisitor perform: self visitSelector with: self.
]

{ #category : #'*Rita-Navigator' }
DAPackageDependency >> visitSelector [
	^ ('visit', self className, ':') asSymbol
]
