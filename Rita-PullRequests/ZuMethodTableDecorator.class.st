Class {
	#name : #ZuMethodTableDecorator,
	#superclass : #ClyTableDecorator,
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #decoration }
ZuMethodTableDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [
"	anItemCellMorph label
		clyAddEmphasis: TextEmphasis bold;
		color: (anItemCellMorph label color contrastingColorAdjustment) contrastingColorAdjustment.
"	
	(anItemCellMorph addExtraIcon: ZuTheme current changeIconSelector)
		setBalloonText: 'This item has changed.'.

	(aDataSourceItem getProperty: ZuChangeProperty) pullRequestConversationItems
		ifNotEmpty: [ :ics |
			(anItemCellMorph addExtraIcon: ZuTheme current conversationIconSelector)
				setBalloonText: 'This item has conversations.'].

	anItemCellMorph color: ZuTheme current cellBackgroundColor.

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
	^ ClyTableDecorationStrategy for: ClyTaggedClassGroup asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> priority [
	^ 9001
]

{ #category : #testing }
ZuMethodTableDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [
	^ aDataSourceItem hasProperty: ZuChangeProperty
]
