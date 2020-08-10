Extension { #name : #SpAbstractListPresenter }

{ #category : #'*Rita' }
SpAbstractListPresenter >> selectItem: anItem scrollToSelection: shouldScrollToSelection [
	self
		selectIndex: (self selection indexOfItem: anItem)
		scrollToSelection: shouldScrollToSelection
]
