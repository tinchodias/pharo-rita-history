Class {
	#name : #RiMultipleDiffsPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
	],
	#category : #'Rita-UI-Diff'
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
	| presenter |
	presenter := self instantiate: RiUnifiedDiffPresenter.
	presenter buildWithSpec.
	presenter model: { 
		#from -> iceNode value rightContents.
		#to -> iceNode value leftContents.
		} asDictionary.

	^ presenter "theWidget
		extent: 300@250;
		scrollbarsShowNever;
		yourself.
"

"	^ (DiffMorph from: iceNode value rightContents to: iceNode value leftContents)
			showOptions: false;
			width: 400;
			height: 200;
			yourself
"
			
"	^ (TextDiffBuilder
			buildDisplayPatchFrom: iceNode value rightContents
			to: iceNode value leftContents) asMorph
			lock: true;
			yourself
"
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> initializePresenters [

	table := self instantiate: RiUnifiedDiffPresenter.

"	table := self newComponentList."

"	table := self newTable
		hideColumnHeaders;
		addColumn: (SpImageTableColumn
			evaluated: [ :each | self tableMorphFor: each ]);
		whenBuiltDo: [ :ann | 
			ann widget beRowNotHomogeneous.
			RiMultipleDiffDataSource adoptInstance: ann widget dataSource ];
		yourself"
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> newPresenterFor: iceNode [
"	^ self pathPresenterWith: iceNode allPathSegments"
	| presenter |
	presenter := self instantiate: RiUnifiedDiffPresenter.
"	presenter buildWithSpec."
	self setIceNode: iceNode in: presenter.
	presenter extent: 400 asPoint.
	
	^ presenter
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
RiMultipleDiffsPresenter >> pathPresenterWith: segments [

	| separator |
	separator := 
		' / ' asText 
			addAttribute: (TextColor color: Color lightGray); 
			addAttribute: (TextFontChange fontNumber: 1); 
			yourself.
	
	^ SpLabelPresenter new
		label: (separator join: (segments collect: [ :each | 
			each asString asText 
				addAttribute: (TextColor color: Smalltalk ui theme caretColor); 
				addAttribute: (TextFontChange fontNumber: 2); 
				yourself ]));
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> refreshOnModelUpdate [
	
"	table items: ((model at: #diffQuery) allChildrenn
		collect: [ :each | self newPresenterFor: each ])"
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

	self setIceNode: anIceNode in: table
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> setIceNode: iceNode in: presenter [
	iceNode ifNil: [ ^self ].
	presenter model: { 
		#from -> iceNode value rightContents.
		#to -> iceNode value leftContents.
		} asDictionary
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

	^ "self rowMorphWithAll: {"
		"self columnMorphWithAll: {
			(self pathMorphWith: iceNode allPathSegments)."
			(self diffMorphFor: iceNode)
		
]
