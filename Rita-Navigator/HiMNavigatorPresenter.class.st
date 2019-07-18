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

{ #category : #private }
HiMNavigatorPresenter >> fillLastView [

	| builder |
	lastNavigator := HiMNavigator newOn: lastView.
	builder := HiMImageDependenciesBuilder new
		navigator: lastNavigator;
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. "'Random-Core'"". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build.

	searchPresenter searchModel topParentNodes: builder topLevelNodes.
	
	lastView camera scale: 5.
	
	lastView when: TSMouseClick do: [ lastView morph takeKeyboardFocus ]
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> highlightAllSearchResults [
	| highlightableForCurrentSearchResult allSearchResults elementsForAllSearchResults |

	searchPresenter isHighlightAllEnabled ifFalse: [ ^self ].

	allSearchResults := searchPresenter lastResultModel nodes.
	allSearchResults ifEmpty: [ ^self ].

	highlightableForCurrentSearchResult := RSHighlightable new
		noDefaultColor;
		highlightElements: [ :each | {each attributeAt: #RSLabeled} ];
		attributeKey: #allSearchResults;
		when: TSHighlightEvent do: [ :evt |
			self highlightCompositeElementWithLabel: evt element k: 0.5 ];
		when: TSUnHighlightEvent do: [ :evt |
			self unhighlightCompositeElementWithLabel: evt element ].
	
	elementsForAllSearchResults := allSearchResults
		collect: [:each | lastView elementFromModel: each ]
		thenReject: #isNil.
	
	highlightableForCurrentSearchResult doHighlightElements: elementsForAllSearchResults.
	
	lastView signalUpdate
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> highlightCompositeElementWithLabel: element k: k [

	| ranges font label searchResultColor searchedText highlightShapeBuidler highlightBorder |
	searchResultColor := Color yellow.
	searchedText := searchPresenter searchModel text.
	highlightShapeBuidler := RSShapeBuilder box
		color: (searchResultColor alpha: 0.15 * k);
		yourself.
	highlightBorder := TSBorder new color: (searchResultColor alpha: 0.5 * k); width: 2 * k.


	element pushFront.
	label := element shapes last.
	font := label font.
	label color: (searchResultColor alpha: k).
	ranges := label text allRangesOfSubstring: searchedText.
	ranges do: [ :interval |
		| boxElement x partial |
		boxElement := highlightShapeBuidler element
			extent: (font widthOfString: searchedText)@font height;
			border: highlightBorder;
			yourself.
		partial := font widthOfString: (label text copyFrom: 1 to: (interval first - 1)).
		x := partial + ((boxElement width - label width) / 2) - 2.
		boxElement position: x@0.
		element shapes addFirst: boxElement ]

]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> highlightCurrentSearchResult [
	| highlightableForCurrentSearchResult topLevelElement aHiMNode |
	searchPresenter lastResultModel hasResults ifFalse: [ ^self ].
	
	aHiMNode := searchPresenter lastResultModel currentNode.

	highlightableForCurrentSearchResult := RSHighlightable new
		noDefaultColor;
		attributeKey: #searchResult;
		highlightElements: [ :each | {each attributeAt: #RSLabeled} ];
		when: TSHighlightEvent do: [ :evt |
			self highlightCompositeElementWithLabel: evt element k: 1 ];
		when: TSUnHighlightEvent do: [ :evt |
			self unhighlightCompositeElementWithLabel: evt element.
			self highlightCompositeElementWithLabel: evt element k: 0.5 ].

	topLevelElement := lastView elementFromModel: aHiMNode topParent.
"	lastNavigator executeAndRegisterExpandIfPossible: topLevelElement."

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
	viewPresenter := (self instantiate: RoassalPresenter)
		script: [ :newView |
			lastView := newView.
			self fillLastView ];
		yourself.

	searchPresenter := (self instantiate: HiMSearchPresenter)
		newResultIndexBlock: [ self highlightCurrentSearchResult ];
		newResultsBlock: [ self highlightAllSearchResults ];
		yourself.

]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> unhighlightCompositeElementWithLabel: element [
	| label normalColor |
	normalColor := Color white.
	label := element shapes last.
	label color: normalColor.
	element shapes removeFirst: element shapes size - 1
]
