"
I'm responsible of building the image (a Morph) to show in the Hiedra column of RiRepositoryPresenter.

"
Class {
	#name : #RiHiedraImageBuilder,
	#superclass : #Object,
	#instVars : [
		'hiedraColumnController'
	],
	#category : #'Rita-UI-Morphic'
}

{ #category : #refreshing }
RiHiedraImageBuilder >> doRefreshWith: aRiRepositoryPresenter [

	hiedraColumnController := HiColumnController new.
	hiedraColumnController renderer
		rowHeight: aRiRepositoryPresenter rowHeightForHiedra;
		nodeRadius: 1.5;
		nodeBorderWidth: 3.0;
		arrowSize: 0;
		nodeConnectionOffset: 3;
		cellWidth: 6.75.
	
	"Create a new ruler model with current table elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: aRiRepositoryPresenter riRepository elements
		linksBlock: [ :each | each ancestors ]).

	hiedraColumnController reset.

]

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [
	^ hiedraColumnController cellMorphAtValue: item
]

{ #category : #refreshing }
RiHiedraImageBuilder >> refreshWith: aRiRepositoryPresenter [

	[ self doRefreshWith: aRiRepositoryPresenter ] future
		onSuccessDo: [ :result | aRiRepositoryPresenter refreshOnAvatarsUpdate ];
		onFailureDo: [ :error | aRiRepositoryPresenter reportWarning: error ]
]
