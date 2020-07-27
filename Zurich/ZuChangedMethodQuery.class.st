Class {
	#name : #ZuChangedMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #Zurich
}

{ #category : #accessing }
ZuChangedMethodQuery >> decorateMethodGroupTableCell: arg1 of: arg2 [
	super decorateMethodGroupTableCell: arg1 of: arg2.
	arg1
		color: ZuTheme current cellBackgroundColor";
		definitionIcon: ZuTheme current changeIconSelector"
]

{ #category : #printing }
ZuChangedMethodQuery >> description [
	^ 'Changed Methods'
]

{ #category : #testing }
ZuChangedMethodQuery >> selectsMethod: arg1 [
	| tmp1 |
	tmp1 := self environment getPlugin: ZuEnvironmentPlugin.
	^ tmp1 doesMethodHaveChange: arg1
]
