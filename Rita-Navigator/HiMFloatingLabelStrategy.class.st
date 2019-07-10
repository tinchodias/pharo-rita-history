Class {
	#name : #HiMFloatingLabelStrategy,
	#superclass : #HiMLabelStrategy,
	#instVars : [
		'edgeBuilder'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #applying }
HiMFloatingLabelStrategy >> applyAfterAddingElements: elements [
	
	elements do: [ :each |
		| label edge mockEdge |
		label := self shapeBuilder elementOn: each model object.
		edge := self edgeBuilder "withBorderAttachPoint" from: each; to: label; edge.
		navigator view add: label; add: edge.
		navigator layout
			addNodes: { label };
			addEdges: { edge }.
		mockEdge := navigator layout mockEdgeAt: edge.
		mockEdge 
			length: (navigator edgeLengthFor: edge);
			strength: 5. ]

	
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
