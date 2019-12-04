Class {
	#name : #RiMultipleDiffsPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiMultipleDiffsPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> columnMorphWithAll: someMophs [

	^ PanelMorph new
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellInset: 8;
		addAllMorphs: someMophs;
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> diffMorphFor: iceNode [
"	| presenter |
	presenter := self instantiate: RiUnifiedDiffPresenter.
	presenter buildWithSpec.
	presenter model: { 
			#from -> iceNode value rightContents.
			#to -> iceNode value leftContents } asDictionary.

	^ presenter theWidget
		extent: 300@250;
		scrollbarsShowNever;
		yourself.
"
"	^ (DiffMorph from: iceNode value rightContents to: iceNode value leftContents)
			showOptions: false;
			width: 400;
			height: 200;
			yourself"
			
	^ (TextDiffBuilder
			buildDisplayPatchFrom: iceNode value rightContents
			to: iceNode value leftContents) asMorph
			lock: true;
			yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> initializePresenters [
	table := self newTable.
	table
		hideColumnHeaders;
		addColumn: (SpImageTableColumn
			evaluated: [ :each | self tableMorphFor: each ]);
		whenBuiltDo: [ :ann | 
			"HACKS HERE"
			ann widget beRowNotHomogeneous.
			SpMultipleDiffDataSource adoptInstance: ann widget dataSource ]
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> pathMorphWith: segments [

	| separator |
	separator := 
		' / ' asText 
			addAttribute: (TextColor color: Color lightGray); 
			addAttribute: (TextFontChange fontNumber: 1); 
			yourself. 
	
	^ (separator join: (segments collect: [ :each | 
			each asString asText 
				addAttribute: (TextColor color: Smalltalk ui theme caretColor); 
				addAttribute: (TextFontChange fontNumber: 2); 
				yourself ])) 
		asMorph
		lock: true;
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> refreshOnModelUpdate [
	table items: (model at: #diffQuery) allChildrenn
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> rowMorphWithAll: someMophs [

	^ PanelMorph new
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellInset: 3;
		addAllMorphs: someMophs;
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> selectIceNode: anIceNode [
"	1halt."
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> tableMorphFor: iceNode [
	"	| presenter |
	presenter := self instantiate: RiUnifiedDiffPresenter.
	presenter buildWithSpec.
	presenter model: { 
			#from -> iceNode value rightContents.
			#to -> iceNode value leftContents } asDictionary.

	^ presenter theWidget
		extent: 300@250;
		scrollbarsShowNever;
		yourself."

	^ self rowMorphWithAll: {
		self columnMorphWithAll: {
			(self pathMorphWith: iceNode allPathSegments).
			(self diffMorphFor: iceNode)
		} }
]
