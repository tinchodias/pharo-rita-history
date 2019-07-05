Class {
	#name : #RiPackageDiffPresenter,
	#superclass : #RiUMLDiffPresenter,
	#category : #'Rita-IceTip'
}

{ #category : #private }
RiPackageDiffPresenter >> buildDiffOn: view [

	| visitor elements theme border uml compositeShape classNameShape classShape |
	visitor := RiIceDiffEntityCollector new.
	iceDiffModel tree accept: visitor.

	theme := Smalltalk ui theme.
	view color: theme backgroundColor.
	border := TSBorder new color: theme textColor; yourself.
	
	uml := RSUMLClassBuilder new.
	classNameShape := RiUMLDiffUtils new shapeForClassOrTrait.
	classShape := RSShapeBuilder composite shapes: [ :node | 
		| name box |
		name := classNameShape elementOn: node.
		box := TSBox new
			noPaint;
			border: border;
			extent: name extent +5.
		name position: 0@0.
		TSGroup with: box with: name.
		].
	
	uml shape: classShape.
	uml classDescriptor
		superclass: nil.
	uml layout grid lineItemsCount: 3.
	
	
	compositeShape := RSShapeBuilder composite 
		color: [ :pkg | (self packageColorScale scale: pkg key) alpha: 0.2 ];
		shapes: [:pkg | | group classes |
			classes := pkg children select: [:each | each value definition isClassDefinition ].
			group := TSGroup new.
			uml view: group.
			uml classes: classes.
			uml build.
			group 
			];
		@RSDraggable;
		padding: 10.
	
	elements := compositeShape elementsOn: visitor nodesWithPackages.
	view addAll: elements.
	RSGridLayout on: elements.
	self addInteractions: view.
]
