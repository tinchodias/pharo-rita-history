Extension { #name : #SpAbstractListPresenter }

{ #category : #'*Rita-UI' }
SpAbstractListPresenter >> selectItem: anItem scrollToSelection: shouldScrollToSelection [
	self
		selectIndex: (self selection indexOfItem: anItem)
		scrollToSelection: shouldScrollToSelection
]
