Class {
	#name : #HiMNavigatorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'viewPresenter',
		'searchPresenter',
		'lastView',
		'lastNavigator'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMNavigatorPresenter class >> defaultSpec [
	<spec>
	<script: 'self new openWithSpec'>
	
	^ SpBoxLayout newVertical 
			spacing: 5;
			add: #viewPresenter;
			add: #searchPresenter 
				withConstraints: [ :constraints | 
					constraints height: self toolbarHeight];
		yourself.
				
]

{ #category : #initialization }
HiMNavigatorPresenter >> fillLastView [

	| builder |
	lastNavigator := HiMNavigator newOn: lastView.
	builder := HiMImageDependenciesBuilder new
		navigator: lastNavigator;
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. "'Random-Core'"". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build.

	searchPresenter searchModel topParentNodes: builder topLevelNodes.
	
	lastView camera scale: 5
]

{ #category : #'as yet unclassified' }
HiMNavigatorPresenter >> highlightAllSearchResults [
	| highlightableForCurrentSearchResult anyNode someHiMNodes |
	someHiMNodes := searchPresenter lastResultModel nodes.
	
	someHiMNodes ifEmpty: [ ^self ].
	anyNode := someHiMNodes anyOne.
	
	highlightableForCurrentSearchResult := RSHighlightable new
		noDefaultColor;
		highlightElements: [ :dontCareItsHacking | 
			someHiMNodes collect: [:each | lastView elementFromModel: each ] thenReject: #isNil ];
		attributeKey: #allSearchResults;
		when: TSHighlightEvent
			do: [ :evt | evt element border: (TSBorder new color: (Color green alpha: 0.5); width: 1; yourself) ];
		when: TSUnHighlightEvent do: [ :evt | evt element border: nil ].

	highlightableForCurrentSearchResult doHighlight: (lastView elementFromModel: anyNode topParent).
	
	lastView signalUpdate
]

{ #category : #'as yet unclassified' }
HiMNavigatorPresenter >> highlightCurrentSearchResult [
	| highlightableForCurrentSearchResult topLevelElement aHiMNode |
	searchPresenter lastResultModel hasResults ifFalse: [ ^self ].
	
	aHiMNode := searchPresenter lastResultModel currentNode.

	highlightableForCurrentSearchResult := RSHighlightable new
		noDefaultColor;
		attributeKey: #searchResult;
		when: TSHighlightEvent
			do: [ :evt | evt element border: (TSBorder new color: Color green; width: 1; yourself) ];
		when: TSUnHighlightEvent do: [ :evt | self highlightAllSearchResults ].

	topLevelElement := lastView elementFromModel: aHiMNode topParent.
	lastNavigator executeAndRegisterExpandIfPossible: topLevelElement.

	(topLevelElement elementFromModel: aHiMNode)
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
		self fillLastView ].

	searchPresenter := self instantiate: HiMSearchPresenter.
	searchPresenter
		newResultIndexBlock: [ self highlightCurrentSearchResult ];
		newResultsBlock: [ self highlightAllSearchResults ].


]
