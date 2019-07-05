Class {
	#name : #HiMFloatingLabelStrategy,
	#superclass : #HiMLabelStrategy,
	#instVars : [
		'edgeBuilder'
	],
	#category : #'Rita-Navigator'
}

{ #category : #applying }
HiMFloatingLabelStrategy >> applyAfterAddingElements: elements [
	
	elements do: [ :each |
		| label edge |
		label := self shapeBuilder elementOn: each model object.
		edge := self edgeBuilder from: each; to: label; edge.
		navigator view add: label; add: edge.
		navigator layout
			addNodes: { label };
			addEdge: edge;
			set: edge length: 1;
			set: edge strength: 3 ]

	
]

{ #category : #applying }
HiMFloatingLabelStrategy >> edgeBuilder [ 
	^ edgeBuilder ifNil: [
		edgeBuilder := RSSingleEdgeBuilder line
			width: 0.25;
			color: (navigator currentTheme textColor alpha: 0.25);
			dashArray: #(0.25);
			yourself ]

]

{ #category : #accessing }
HiMFloatingLabelStrategy >> edgeBuilder: anObject [
	edgeBuilder := anObject
]
