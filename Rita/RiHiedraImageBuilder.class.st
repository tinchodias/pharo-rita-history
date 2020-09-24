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

{ #category : #accessing }
RiHiedraImageBuilder >> morphAt: item [

	self flag: #todo. "Fix this async problem in other way"

	^ (hiedraColumnController notNil and: [ hiedraColumnController isReady ])
		ifFalse: [ ^ Morph new ]
		ifTrue: [ hiedraColumnController cellMorphAtValue: item ]
]

{ #category : #refreshing }
RiHiedraImageBuilder >> process: aRiRepository rowHeight: aHeight [

	hiedraColumnController := HiColumnController new.
	hiedraColumnController renderer
		rowHeight: aHeight;
		nodeRadius: 1.5;
		nodeBorderWidth: 3.0;
		arrowSize: 0;
		nodeConnectionOffset: 3;
		cellWidth: 6.75.
	self setUniformColors.

	"Create a new ruler model with current table elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: aRiRepository elements
		linksBlock: [ :each | each ancestors ]).

	hiedraColumnController reset.

]

{ #category : #accessing }
RiHiedraImageBuilder >> setMultipleColors [

	hiedraColumnController renderer useWheelColorStrategy.
	hiedraColumnController renderer colorStrategy
		colorWheel: ((Color 
			wheel: 5
			saturation: 0.45 
			brightness: 0.95)
		collect: [ :each | each mixed: 0.75 with: Smalltalk ui theme textColor ]).
		

]

{ #category : #accessing }
RiHiedraImageBuilder >> setUniformColors [

	hiedraColumnController renderer useUniformColorStrategy.
	hiedraColumnController renderer colorStrategy
		linkColor: Smalltalk ui theme textColor;
		nodeColor: Smalltalk ui theme textColor
]
