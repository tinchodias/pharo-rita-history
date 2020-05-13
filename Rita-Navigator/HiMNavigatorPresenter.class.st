Class {
	#name : #HiMNavigatorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'viewPresenter',
		'searchPresenter',
		'lastView',
		'lastNavigator',
		'packageNames'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMNavigatorPresenter class >> defaultSpec [
	<spec>
	
	^ SpBoxLayout newVertical 
			spacing: 5;
			add: #viewPresenter;
			add: #searchPresenter 
				withConstraints: [ :constraints | 
					constraints height: self labelHeight + 5 ];
		yourself.
				
]

{ #category : #examples }
HiMNavigatorPresenter class >> example1 [ 
	^ (self new
		setModelBeforeInitialization: {'Hiedra'. 'Hiedra-Tests'. 'Athens-Cairo'. "'Growl'. 'Iceberg'"};
		openWithSpec)
		withWindowDo: [ :window | 
			window
				extent: 1000 @ 800;
				title: self name, ' - Roassal3 in Spec2' ]
]

{ #category : #private }
HiMNavigatorPresenter >> fillLastView [

	| builder |
	lastNavigator := HiMNavigator newOn: lastView.
	builder := HiMImageDependenciesBuilder new
		navigator: lastNavigator;
		packageNames: packageNames;
		build.

	searchPresenter searchModel topParentNodes: builder topLevelNodes.
	lastView camera scale: 6.
	lastView when: RSMouseClick do: [ lastView morph takeKeyboardFocus ].
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> highlightAllSearchResults [
	| highlightableForCurrentSearchResult allSearchResults elementsForAllSearchResults |

	allSearchResults := searchPresenter lastResultModel nodes.

	highlightableForCurrentSearchResult := RSHighlightable new
		highlightShapes: [ :each | {each attributeAt: #RSLabeled} ];
		propertyKey: #allSearchResults;
		when: RSHighlightEvent do: [ :evt |
			self highlightCompositeElementWithLabel: evt element intensity: 0.5 ];
		when: RSUnHighlightEvent do: [ :evt |
			self unhighlightCompositeElementWithLabel: evt element ].
	
	elementsForAllSearchResults := allSearchResults
		collect: [:each | lastView shapeFromModel: each ]
		thenReject: #isNil.
	
	self shouldHighlightAll
		ifTrue: [
			highlightableForCurrentSearchResult doHighlightShapes: elementsForAllSearchResults ]
		ifFalse: [ 
			highlightableForCurrentSearchResult unhighlightRecordedShapes: lastView ].
	
	lastView signalUpdate
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> highlightCompositeElementWithLabel: element intensity: k [

	| ranges font label highlightColor searchedText highlightShapeBuilder backgroundColor |
	"search result model"
	label := element shapes last.
	searchedText := searchPresenter searchModel text.
	ranges := label text allRangesOfSubstring: searchedText.

	"visualize"
	highlightColor := lastNavigator currentTheme warningTextColor.
	backgroundColor := lastNavigator currentTheme backgroundColor alpha: 0.5.
	element color: backgroundColor.
	element border: (RSBorder new color: (highlightColor alpha: k); width: 3 * k; yourself).
	element pushFront.

	highlightShapeBuilder := RSBox new
		color: (highlightColor alpha: k * 0.5);
"		border: (TSBorder new color: (highlightColor alpha: k * 0.5); width: 2 * k; yourself);"
		yourself.

	font := label font.
	ranges do: [ :interval |
		| boxElement x partial |
		boxElement := highlightShapeBuilder element
			extent: (font widthOfString: searchedText)@font height;
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
		propertyKey: #searchResult;
		highlightShapes: [ :each | {each attributeAt: #RSLabeled} ];
		when: RSHighlightEvent do: [ :evt |
			self highlightCompositeElementWithLabel: evt element intensity: 1 ];
		when: RSUnHighlightEvent do: [ :evt |
			self unhighlightCompositeElementWithLabel: evt element.
			self shouldHighlightAll 
				ifTrue: [ self highlightCompositeElementWithLabel: evt element intensity: 0.5 ] ].

	self flag: #todo.
	highlightableForCurrentSearchResult highlightShape. "TODO: Needed to ensure a slot has been initialized."

	topLevelElement := lastView shapeFromModel: aHiMNode topParent.
	lastNavigator executeAndRegisterExpandIfPossible: topLevelElement.

	(topLevelElement shapeFromModel: aHiMNode)
		ifNotNil: [ :element | 
			highlightableForCurrentSearchResult doHighlight: element ]
		ifNil: [
			(lastView shapeFromModel: aHiMNode topParent) ifNotNil:
				[ :element | highlightableForCurrentSearchResult doHighlight: element ] ].
		
	lastView signalUpdate
]

{ #category : #initialization }
HiMNavigatorPresenter >> initializeWidgets [
	viewPresenter := (self instantiate: SpRoassalPresenter)
		script: [ :newView |
			lastView := newView.
			self fillLastView ];
		yourself.

	searchPresenter := (self instantiate: HiMSearchPresenter)
		newResultIndexBlock: [ self highlightCurrentSearchResult ];
		newResultsBlock: [ self highlightAllSearchResults ];
		toggledHighlightAllBlock: [ 
			self highlightAllSearchResults; highlightCurrentSearchResult ];
		yourself.

	self focusOrder
		add: searchPresenter;
		add: viewPresenter
]

{ #category : #private }
HiMNavigatorPresenter >> setModelBeforeInitialization: somePackageNames [
	packageNames := somePackageNames
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> shouldHighlightAll [
	^ searchPresenter isHighlightAllEnabled and: [ searchPresenter lastResultModel hasResults ]
]

{ #category : #'private - searching' }
HiMNavigatorPresenter >> unhighlightCompositeElementWithLabel: element [
	| label normalColor |
	normalColor := lastNavigator currentTheme textColor.
	label := element shapes last.
	label color: normalColor.
	
	element
		border: nil;
		color: nil.
	
	element shapes removeFirst: element shapes size - 1
]
