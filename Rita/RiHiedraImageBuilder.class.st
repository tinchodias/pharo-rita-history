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
		cellWidth: 6.75;
		useUniformColorStrategy.
	hiedraColumnController renderer colorStrategy
		linkColor: Smalltalk ui theme textColor;
		nodeColor: Smalltalk ui theme textColor.
"	hiedraColumnController renderer colorStrategy
		colorWheel: ((Color 
			wheel: 5
			saturation: 0.45 
			brightness: 0.95)
		collect: [ :each | each mixed: 0.75 with: Smalltalk ui theme textColor ]).
"		
	"Create a new ruler model with current table elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: aRiRepositoryPresenter riRepository elements
		linksBlock: [ :each | each ancestors ]).

	hiedraColumnController reset.

]

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [
	self flag: #todo. "Fix this async problem in other way"
	hiedraColumnController ifNil: [ ^ Morph new ].
	^ hiedraColumnController cellMorphAtValue: item
]

{ #category : #refreshing }
RiHiedraImageBuilder >> refreshWith: aRiRepositoryPresenter [

	[ self doRefreshWith: aRiRepositoryPresenter ] future
		onSuccessDo: [ :result | aRiRepositoryPresenter refreshOnAvatarsUpdate ];
		onFailureDo: [ :error | aRiRepositoryPresenter reportWarning: error ]
]
