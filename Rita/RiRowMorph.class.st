"
I'm a Morph that's useful as a list or table row. Submorphs can be added at left or right.
"
Class {
	#name : #RiRowMorph,
	#superclass : #Morph,
	#instVars : [
		'leftPanel',
		'rightPanel'
	],
	#category : #'Rita-UI-Morphic'
}

{ #category : #accessing }
RiRowMorph >> addItemLeft: aMorph [

	leftPanel addMorphBack: (aMorph
		vResizing: #spaceFill;
		yourself)
]

{ #category : #accessing }
RiRowMorph >> addItemRight: aMorph [

	rightPanel addMorphBack: (aMorph
		vResizing: #spaceFill;
		yourself)
]

{ #category : #initialization }
RiRowMorph >> initialize [
	super initialize.

	self
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		color: Color transparent;
		extent: 0@0.
	
	self initializePanels
]

{ #category : #initialization }
RiRowMorph >> initializePanels [

	leftPanel := self newPanelMorph.
	rightPanel := self newPanelMorph
		listDirection: #rightToLeft;
		hResizing: #shrinkWrap.

	self
		addMorphBack: leftPanel;
		addMorphBack: rightPanel

]

{ #category : #'private factory' }
RiRowMorph >> newPanelMorph [

	^ Morph new 
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		cellInset: 3@0;
		extent: 0@0;
		color: Color transparent;
		yourself
]
