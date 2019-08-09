Class {
	#name : #RiClassDiffPresenter,
	#superclass : #RiUMLDiffPresenter,
	#category : #'Rita-IceTip-DiffView'
}

{ #category : #private }
RiClassDiffPresenter >> buildDiffOn: view [
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

	builder modelDescriptor
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
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i draggable; popupText: #key ];
		shapes: [ :m | builder createShapesFor: m ]).
	builder renderer classBoxShape
		color: [ :node | (self packageColorScale scale: node key) alpha: 0.3 ].
	self setupRendererOn: builder.
	
	builder classes: classesByName values.
	builder build.
	self addInteractions: view.
]
