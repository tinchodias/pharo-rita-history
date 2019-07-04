Class {
	#name : #RiHiedraImageBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraColumnController',
		'table'
	],
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiHiedraImageBuilder >> initialize [
	super initialize.
	
	hiedraColumnController := HiRS3ColumnController new.
	hiedraColumnController rowHeight: FTTableMorph defaultRowHeight floor.

]

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [
	^ hiedraColumnController cellMorphAtValue: item
]

{ #category : #'as yet unclassified' }
RiHiedraImageBuilder >> refreshWith: someRiElements [

	"Create a new ruler model with the new elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: someRiElements
		linksBlock: [ :each | each ancestors ]).

	hiedraColumnController reset.

]

{ #category : #'as yet unclassified' }
RiHiedraImageBuilder >> setTable: aFTTableMorph [
	table := aFTTableMorph.
	
	hiedraColumnController
		table: table;
		onChangeDo: [ table ifNotNil: [ table changed ] ].
	
	table columns first width: hiedraColumnController rulerWidth.
	
	self refreshWith: aFTTableMorph dataSource elements.
]
