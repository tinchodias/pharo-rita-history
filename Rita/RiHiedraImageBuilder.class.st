"
I'm responsible of building the image (a Morph) to show in the Hiedra column of RiRepositoryPresenter.

"
Class {
	#name : #RiHiedraImageBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraColumnController'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [
	^ hiedraColumnController isReady
		ifTrue: [ hiedraColumnController cellMorphAtValue: item ]
		ifFalse: [ Morph new color: Color transparent; extent: 10@10 ]
]

{ #category : #refreshing }
RiHiedraImageBuilder >> refreshWith: aRiRepositoryPresenter [

	[ 	
		"Create a new ruler model with current table elements"
		hiedraColumnController ruler: (HiRulerBuilder
			newRulerValues: aRiRepositoryPresenter riRepository elements
			linksBlock: [ :each | each ancestors ]).

		hiedraColumnController reset.
	
	] future onSuccessDo: [ :result |
		aRiRepositoryPresenter refreshOnAvatarsUpdate ]
]

{ #category : #accessing }
RiHiedraImageBuilder >> tableMorph: aFTTableMorph [
	"This object isn't completely initialized until this method receives the table where the Hiedra will belong."

	hiedraColumnController := HiColumnController new.
	hiedraColumnController renderer
		rowHeight: aFTTableMorph rowHeight floor;
		nodeRadius: 1.5;
		nodeBorderWidth: 3.0;
		arrowSize: 0;
		nodeConnectionOffset: 3;
		cellWidth: 6.75.
]
