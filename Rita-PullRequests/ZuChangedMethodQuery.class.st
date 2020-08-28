Class {
	#name : #ZuChangedMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #accessing }
ZuChangedMethodQuery >> decorateMethodGroupTableCell: anItemCellMorph of: groupItem [
	super decorateMethodGroupTableCell: anItemCellMorph of: groupItem.
	
	anItemCellMorph color: ZuTheme current cellBackgroundColor.
	anItemCellMorph definitionIcon: ZuTheme current changeIconSelector.
]

{ #category : #printing }
ZuChangedMethodQuery >> description [
	^ 'Changed Methods'
]

{ #category : #testing }
ZuChangedMethodQuery >> selectsMethod: aMethod [
	| plugin |
	plugin := self environment getPlugin: ZuEnvironmentPlugin.
	^ plugin doesMethodHaveChange: aMethod
]
