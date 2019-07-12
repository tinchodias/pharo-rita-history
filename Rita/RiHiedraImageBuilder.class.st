"
I'm responsible of building the image (a Morph) to show in the Hiedra column of RiRepositoryPresenter.

"
Class {
	#name : #RiHiedraImageBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraColumnController',
		'morphTable'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [
	^ hiedraColumnController cellMorphAtValue: item
]

{ #category : #refreshing }
RiHiedraImageBuilder >> refreshWith: someRiElements [

	"Create a new ruler model with current table elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: someRiElements
		linksBlock: [ :each | each ancestors ]).

	hiedraColumnController reset.

	morphTable columns first width: hiedraColumnController rulerWidth.

]

{ #category : #accessing }
RiHiedraImageBuilder >> tableMorph: aFTTableMorph [
	"This object isn't completely initialized until this method receives the table where the Hiedra will belong."

	morphTable := aFTTableMorph.
	
	hiedraColumnController := HiRS3ColumnController new.
	hiedraColumnController
		table: morphTable;
		onChangeDo: [ morphTable changed ];
		rowHeight: morphTable rowHeight "floor".

]
