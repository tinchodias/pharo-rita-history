Class {
	#name : #RSRectangleRepulsionForceLayout,
	#superclass : #RSForceBasedLayout,
	#instVars : [
		'repulsionForce'
	],
	#category : #'Rita-Navigator'
}

{ #category : #initialization }
RSRectangleRepulsionForceLayout class >> exampleBoth [
	self
		exampleON;
		exampleOFF
]

{ #category : #initialization }
RSRectangleRepulsionForceLayout class >> exampleOFF [
	^ self openWithLayoutClass: RSForceBasedLayout
]

{ #category : #initialization }
RSRectangleRepulsionForceLayout class >> exampleON [
	^ self openWithLayoutClass: RSRectangleRepulsionForceLayout
]

{ #category : #initialization }
RSRectangleRepulsionForceLayout class >> newElements [
	| labeled verticalNodes horizontalNodes |
	labeled := RSLabeled new.
	labeled shape scaleBy: 0.5.
	labeled location middle.
	
	verticalNodes := (1 to: 10) collect: [ :each | 
		RSElement new
			trachelShape: (TSBox new width: 10; height: 100; color: Color random trans; yourself);
			model: each;
			addInteraction: labeled;
			addInteraction: RSDraggable;
			yourself
		 ].
	horizontalNodes := (1 to: 10) collect: [ :each | 
		RSElement new
			trachelShape: (TSBox new width: 100; height: 10; color: Color random trans; yourself);
			model: each;
			addInteraction: labeled;
			addInteraction: RSDraggable;
			yourself ].

	^ verticalNodes, horizontalNodes
]

{ #category : #initialization }
RSRectangleRepulsionForceLayout class >> openWithLayoutClass: layoutClass [

	| view nodes layout |
	nodes := self newElements.
	layout := layoutClass new
		start: nodes;
		yourself.

	view := RSView new.
	view addAll: nodes.

	view newAnimation
		easing: TSEasing cubicInOut;
		from: 0.1;
		to: 0.0;
		duration: 5 seconds;
		onStepDo: [ :t | layout alpha: t; step ].
	
	view addInteraction: RSActivityMonitorView.
	view camera scale: 2.
	view open setLabel: layout className.

]

{ #category : #events }
RSRectangleRepulsionForceLayout >> initialize [
	super initialize.

	repulsionForce := 0.5

]

{ #category : #events }
RSRectangleRepulsionForceLayout >> step [
	self stepRectangleRepulsionForces.
	super step.

]

{ #category : #events }
RSRectangleRepulsionForceLayout >> stepRectangleRepulsionForces [
	"Apply a repulsion force between elements that overlap."

	| k alreadyVisited |
	k := repulsionForce * alpha.
	
	alreadyVisited := OrderedCollection new.
	
	nodes do: [ :each |
		| eachRect |
		eachRect := each encompassingRectangle.

		alreadyVisited do: [ :another |
			| anotherRect escapePoint areas |
			anotherRect := another encompassingRectangle.

			(anotherRect intersects: eachRect) ifTrue: [ 
				areas := anotherRect areasOutside:  eachRect.
				escapePoint := areas
					ifEmpty: [ 0 asPoint " <--- just arbitrary! "]
					ifNotEmpty: [ eachRect rsCenter - (areas detectMax: #area) rsCenter ].
				each translateTo: each position + (k * escapePoint) ] ].

		alreadyVisited add: each ].

]
