Class {
	#name : #RiTorchLikeDiffPresenter,
	#superclass : #RiUMLDiffPresenter,
	#category : #'Rita-IceTip-DiffView-TorchLike'
}

{ #category : #private }
RiTorchLikeDiffPresenter >> backgroundColorFor: node [
	^ node value ritaColor alphaMixed: 0.25 with: Smalltalk ui theme backgroundColor
]

{ #category : #private }
RiTorchLikeDiffPresenter >> buildDiffOn: view [
	| visitor builder classesByName metaclassesByName |
	visitor := RiIceDiffEntityCollector new.
	iceDiffModel tree accept: visitor.
			
	classesByName := Dictionary new.
	metaclassesByName := Dictionary new.
	visitor nodesWithClasses do: [ :node |
		classesByName at: node key put: node ].
	visitor nodesWithMetaclasses do: [ :node |
		metaclassesByName at: (node key allButLast: ' class' size) put: node ].

	builder := RSUMLClassBuilder new.
	builder view: view.

	builder classDescriptor
		classname: [ :node | node key asString ];
		instVars: [ :node | #() ];
		methods: [ :node |
			| metaclassMethods |
			metaclassMethods := metaclassesByName at: node key ifPresent: [:found | found children ] ifAbsent: [ #() ].
			metaclassMethods, node children ];
		superclass: [ :node | 
			| superclassName |
			superclassName := node value definition asMCDefinition superclassName.
			classesByName at: superclassName ifAbsent: [ nil ] ];
		methodSelector: [ :met | met key asString ].

	self setupRendererOn: builder.

	builder classes: classesByName values.
	builder build.
	self addInteractions: view.
]

{ #category : #private }
RiTorchLikeDiffPresenter >> buildSettingsOn: aView [

	| icon |
	icon := RSShapeBuilder bitmap
		form: (self iconNamed: #configuration);
		element.
	icon isFixed: true.
	aView addShape: icon trachelShape.

"	update := [ 
		RSHorizontalLineLayout on: legendLabels.
		RSLocate new
			inner; top; right;
			move: legendLabels 
				on: aView basicRectangle.
	].
	legendLabels := aView attributes 
		at: #legendLabels
		ifAbsentPut: [ 
			aView when: TSExtentChangedEvent do: update.
			TSGroup new: 5 ].
	legendLabels add: label.
	update value."
]

{ #category : #private }
RiTorchLikeDiffPresenter >> builderForClassName [

	| labelShape |
	labelShape := RSShapeBuilder label
		fontSize: 20;
		color: Smalltalk ui theme textColor;
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: e model key
			font: e font
			maxSize: self maxClassWidth ];
		onModel;
		if: [:node | node value definition isMethodDefinition and: [ node value definition classIsMeta ] ]
			then: [:s | s underline ].
		
	labelShape bold.

	^ RSShapeBuilder composite 
		shapes: [:node | labelShape elementsOn: {node} ];
		interactionDo: [:i | i popupText: [ :node | node key ] ];
		color: [ :node | self backgroundColorFor: node ];
		yourself
]

{ #category : #private }
RiTorchLikeDiffPresenter >> builderForMethods [
	| methodBuilder |
	methodBuilder := RSShapeBuilder box 
		color: [ :node | self foregroundColorFor: node ];
		width: self methodScale * 0.5;
		height: [ :node | node value ritaChangeSize * self methodScale ];
		when: TSMouseClick do: [ :node | [ :evt | self onMouseClickFor: node ] ];
		yourself.

	^ RSShapeBuilder composite shapes: [ :nodeClass |
		| methodElements methods |
		methods := nodeClass children sorted: [ :a :b |
			a value class = b value class
				ifTrue: [ a value ritaChangeSize > b value ritaChangeSize ]
				ifFalse: [ a value class name < b value class name ] ].
		
		methodElements := methodBuilder elementsOn: methods.

		RSFlowLayout new 
			maxWidth: self maxClassWidth;
			gapSize: self methodsGap;
			on: methodElements.
		methodElements ];
		padding: (Margin 
			left: 2
			right: 2
			top: 2 * (self methodsGap - 1)
			bottom: 2).
]

{ #category : #private }
RiTorchLikeDiffPresenter >> classBorderWidth [
	^ 4
]

{ #category : #private }
RiTorchLikeDiffPresenter >> foregroundColorFor: node [
	^ node value ritaColor mixed: 0.8 with: Smalltalk ui theme textColor
]

{ #category : #private }
RiTorchLikeDiffPresenter >> maxClassWidth [
	^ 400
]

{ #category : #private }
RiTorchLikeDiffPresenter >> methodScale [
	^ 30
]

{ #category : #private }
RiTorchLikeDiffPresenter >> methodsGap [
	^ 5
]

{ #category : #private }
RiTorchLikeDiffPresenter >> setupRendererOn: builder [
	| renderer |
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i popupText: #key ];
		shapes: [ :m | | shapes title |
			shapes := builder createShapesFor: m.

			"Expand label's bounding box"
			title := shapes second.
			title extent: shapes width @ 40.

			"Increase and push front the border, and maybe add dashes."
			shapes first border width: self classBorderWidth.
			m value ritaIsNoModification ifTrue: [ shapes first border dashArray: { self classBorderWidth. self classBorderWidth/2 } ].
			shapes swap: 1 with: shapes size.


			shapes ]).

	renderer := builder renderer.

	renderer methodsShape: self builderForMethods.
	renderer classNameShape:
		(self builderForClassName
			when: TSMouseClick do: [ :node | [ self onMouseClickFor: node ] ];
			yourself).

	renderer classBoxShape cornerRadius: 3.

	builder renderer classBoxShape
		noPaint;
		border: [ :node | TSBorder new color: (self foregroundColorFor: node); yourself ].

	self setupSystemThemeOn: builder.

]
