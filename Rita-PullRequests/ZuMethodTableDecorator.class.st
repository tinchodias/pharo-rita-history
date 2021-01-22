"
I am responsible of decorating Calypso table rows/cells.

I define methods as Calypso requires, in class-side. Please refer to my superclass, which has a detailed explanation.
"
Class {
	#name : #ZuMethodTableDecorator,
	#superclass : #ClyTableDecorator,
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #decoration }
ZuMethodTableDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [

	anItemCellMorph color: ZuTheme current cellBackgroundColor.

	(anItemCellMorph addExtraIcon: ZuTheme current changeIconSelector)
		setBalloonText: 'This item has changed.'.

	(aDataSourceItem getProperty: ZuChangeProperty) pullRequestConversationItemsConsideringChildren
		ifNotEmpty: [ :items |
			| toolMorph |
			toolMorph := self toolMorphFor: items. 
			toolMorph setBalloonText: ('This item has {1} conversations.' format: { items size }).
			anItemCellMorph addExtraTool: toolMorph.
		]
]

{ #category : #decoration }
ZuMethodTableDecorator class >> decorationStrategyForClass [

	<classAnnotation>
	^ ClyTableDecorationStrategy for: ClyClass asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> decorationStrategyForMethod [

	<classAnnotation>
	^ ClyTableDecorationStrategy for: ClyMethod asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> decorationStrategyForPackage [

	<classAnnotation>
	^ ClyTableDecorationStrategy for: RPackage asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> decorationStrategyForPackageTag [

	<classAnnotation>
	^ ClyTableDecorationStrategy for:
		  ClyTaggedClassGroup asCalypsoItemContext
]

{ #category : #decoration }
ZuMethodTableDecorator class >> priority [

	^ 9001
]

{ #category : #decoration }
ZuMethodTableDecorator class >> toolMorphFor: items [
	
	| morphFactory |
	morphFactory := EpMorphFactory default.
	
	^ morphFactory rowWithAll: {
		ZuTheme current conversationIcon asMorph.
		('x', items size asString) asMorph.
	}
]

{ #category : #testing }
ZuMethodTableDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [

	^ aDataSourceItem hasProperty: ZuChangeProperty
]
