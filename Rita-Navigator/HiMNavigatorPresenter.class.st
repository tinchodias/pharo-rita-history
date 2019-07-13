Class {
	#name : #HiMNavigatorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'viewPresenter',
		'searchPresenter',
		'lastView'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMNavigatorPresenter class >> defaultSpec [
	<spec>
	<script: 'self new openWithSpec'>
	
	^ SpBoxLayout newVertical 
			add: #viewPresenter;
			add: #searchPresenter 
				withConstraints: [ :constraints | 
					constraints height: self toolbarHeight];
		yourself.
				
]

{ #category : #initialization }
HiMNavigatorPresenter >> fill: aRSView [

	| aHiMNavigator builder |
	aHiMNavigator := HiMNavigator newOn: aRSView.
	builder := HiMImageDependenciesBuilder new
		navigator: aHiMNavigator;
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. "'Random-Core'"". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build.

	searchPresenter searchModel topParentNodes: builder topLevelNodes.
	


]

{ #category : #'as yet unclassified' }
HiMNavigatorPresenter >> highlightOnly: aHiMNode [
	| highlightableForCurrentSearchResult |
	highlightableForCurrentSearchResult := RSHighlightable new
		noDefaultColor;
		attributeKey: #searchResult;
		when: TSHighlightEvent
			do: [ :evt | evt element border: (TSBorder new color: Color green; width: 1; yourself) ];
		when: TSUnHighlightEvent do: [ :evt | evt element border: nil ].

	((lastView elementFromModel: aHiMNode topParent) elementFromModel: aHiMNode)
		ifNotNil: [ :element | 
			highlightableForCurrentSearchResult doHighlight: element ]
		ifNil: [
			(lastView elementFromModel: aHiMNode topParent) ifNotNil:
				[ :element | highlightableForCurrentSearchResult doHighlight: element ] ].
		
	lastView signalUpdate
]

{ #category : #initialization }
HiMNavigatorPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter.
	viewPresenter script: [ :view |
		lastView := view.
		self fill: view.
		view camera scale: 5 ].
		

	searchPresenter := self instantiate: HiMSearchPresenter.
	
	searchPresenter newResultIndexBlock: [ 
		self highlightOnly: searchPresenter lastResultModel currentNode ]
]
