Class {
	#name : #RiRowBuilder,
	#superclass : #Object,
	#category : #'Rita-UI-Support'
}

{ #category : #'mark morph building' }
RiRowBuilder >> localMarkMorphText: text icon: icon [
	^ (self markMorphText: text icon: icon)
		borderStyle: (DashedBorder new
			width: 1;
			dashColors: { self markMorphBorderColor. Color transparent }
				dashLengths: #(2 2);
			yourself);
		yourself
]

{ #category : #'mark morph building' }
RiRowBuilder >> markMorphBorderColor [
	^ Smalltalk ui theme textColor alpha: 0.25
]

{ #category : #'mark morph building' }
RiRowBuilder >> markMorphText: text icon: icon [
	^ Morph new
		layoutInset: 2 @ 0;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (icon darker: 1) asMorph;
		addMorphBack: (' ' , text) asMorph;
		color: Color transparent;
		yourself
]

{ #category : #accessing }
RiRowBuilder >> refreshWith: anObject [

]

{ #category : #'mark morph building' }
RiRowBuilder >> remoteMarkMorphText: text icon: icon [
	^ (self markMorphText: text icon: icon)
		borderStyle: (SimpleBorder new
			width: 1;
			color: self markMorphBorderColor;
			yourself);
		yourself
]
