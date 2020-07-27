Class {
	#name : #ZuMethodTableDecorator,
	#superclass : #ClyTableDecorator,
	#category : #Zurich
}

{ #category : #decoration }
ZuMethodTableDecorator class >> decorateMainTableCell: arg1 of: arg2 [
	| tmp1 |
	super decorateMainTableCell: arg1 of: arg2.
	tmp1 := arg1 addExtraIcon: #uncommentedClass.
	tmp1 setBalloonText: 'There is no comment!'
]

{ #category : #decoration }
ZuMethodTableDecorator class >> decorateTableCell: arg1 of: arg2 [
	(arg1 addExtraIcon: ZuTheme current changeIconSelector)
		setBalloonText: 'This item has changed.'.
	arg1 color: ZuTheme current cellBackgroundColor
]

{ #category : #'as yet unclassified' }
ZuMethodTableDecorator class >> decorationStrategyForClass [
	<classAnnotation>
	^ ClyTableDecorationStrategy for: ClyClass asCalypsoItemContext
]

{ #category : #'as yet unclassified' }
ZuMethodTableDecorator class >> decorationStrategyForMethod [
	<classAnnotation>
	^ ClyTableDecorationStrategy for: ClyMethod asCalypsoItemContext
]

{ #category : #'as yet unclassified' }
ZuMethodTableDecorator class >> decorationStrategyForPackage [
	<classAnnotation>
	^ ClyTableDecorationStrategy for: RPackage asCalypsoItemContext
]

{ #category : #'as yet unclassified' }
ZuMethodTableDecorator class >> decorationStrategyForPackageTag [
	<classAnnotation>
	^ ClyTableDecorationStrategy
		for: ClyTaggedClassGroup asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> priority [
	^ 9001
]

{ #category : #testing }
ZuMethodTableDecorator class >> wantsDecorateTableCellOf: arg1 [
	^ arg1 isMarkedWith: ZuChangedTag
]
