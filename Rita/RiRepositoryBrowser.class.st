"
self example1.
"
Class {
	#name : #RiRepositoryBrowser,
	#superclass : #FTSimpleDataSource,
	#instVars : [
		'hiedraColumnController',
		'marksByCommit'
	],
	#category : #'Rita-UI'
}

{ #category : #examples }
RiRepositoryBrowser class >> example1 [
	self openWith:
		(RiRepositoryModel new
			repository: self exampleRepository;
			process;
			yourself)
]

{ #category : #examples }
RiRepositoryBrowser class >> exampleRepository [
	^ IceRepository registry detect: [ :each | each name beginsWith: 'iceberg' ]
]

{ #category : #examples }
RiRepositoryBrowser class >> openWith: repositoryModel [

	| dataSource table |
	dataSource := self new.

	table := FTTableMorph new
		extent: 500 @ 700;
		addColumn: (FTColumn id: ' ');
		addColumn: ((FTColumn id: 'SHA') width: 60);
		addColumn: (FTColumn id: 'Description');
		addColumn: ((FTColumn id: 'Author') width: 120);
		addColumn: ((FTColumn id: 'Date') width: 120);
		dataSource: dataSource;
		beResizable;
		yourself.
	
	dataSource model: repositoryModel.
	
	table openInWindowLabeled: 'Repository'
]

{ #category : #accessing }
RiRepositoryBrowser >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view."
	
	| item |
	column id = ' ' ifTrue: [
		^ FTCellMorph new
			addMorphBack: (hiedraColumnController cellMorphAtRow: rowIndex);
			yourself ].

	item := self elementAt: rowIndex.

	column id = 'Description' ifTrue: [
		^ FTCellMorph new
			cellInset: 5;
			addAllMorphs: (self markMorphsAt: item);
			addMorphBack: item comment asMorph;
			yourself ].

	column id = 'SHA' ifTrue: [
		^ FTCellMorph new
			addMorphBack: item shortId asMorph;
			yourself ].

	column id = 'Author' ifTrue: [
		^ FTCellMorph new
			addMorphBack: item author asMorph;
			yourself ].

	column id = 'Date' ifTrue: [
		^ FTCellMorph new
			addMorphBack: item date asMorph;
			yourself ].

	^ self error
]

{ #category : #visiting }
RiRepositoryBrowser >> colorForAlreadyPushed [
	^ Color green
]

{ #category : #visiting }
RiRepositoryBrowser >> colorForOnlyLocal [
	^ Color red
]

{ #category : #accessing }
RiRepositoryBrowser >> elements: commits [
	super elements: commits.

	"Adjust the ruler rendering settings with table's row height."
	hiedraColumnController renderer rowHeight: self table rowHeight floor.

	"Create a new ruler model with the new elements"
	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: elements
		linksBlock: [ :each | each ancestors ]).

	"Reset the visualization"
	hiedraColumnController reset.

	"Adjust the column width in the table"
	self table columns first width: hiedraColumnController rulerWidth.

]

{ #category : #visiting }
RiRepositoryBrowser >> iconForBranch [
	^ Smalltalk ui iconNamed: #branch
]

{ #category : #visiting }
RiRepositoryBrowser >> iconForTag [
	^ (self iconNamed: #breakpoint)
		flipBy: #horizontal
		centerAt: 0 @ 0
]

{ #category : #visiting }
RiRepositoryBrowser >> iconForWorkingCopy [
	^ Smalltalk ui iconNamed: #smallSave
]

{ #category : #initialization }
RiRepositoryBrowser >> initialize [

	super initialize.
	hiedraColumnController := HiColumnController new.
	hiedraColumnController renderer
		arrowSize: 0;
		nodeConnectionOffset: 0;
		nodeRadius: 1.75
]

{ #category : #private }
RiRepositoryBrowser >> markMorphText: text icon: icon color: color [
	^ Morph new
		layoutInset: 2 @ 0;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (icon darker: 1) asMorph;
		addMorphBack: (' ' , text) asMorph;
		color: (color alpha: 0.3);
		yourself
]

{ #category : #accessing }
RiRepositoryBrowser >> markMorphsAt: aRiElement [
	^ aRiElement marks collect: [ :each | each accept: self ]
]

{ #category : #accessing }
RiRepositoryBrowser >> menuColumn: column row: rowIndex [
	| element menu |
	element := self elementAt: rowIndex.
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Inspect' target: element selector: #inspect.
	^ menu
]

{ #category : #accessing }
RiRepositoryBrowser >> model: aRiRepositoryModel [

	self elements: aRiRepositoryModel elements
]

{ #category : #visiting }
RiRepositoryBrowser >> visitBranchMark: aRiBranchMark [
	^ self
		markMorphText: aRiBranchMark shortname
		icon: self iconForBranch
		color:
			(aRiBranchMark isOnlyLocal
				ifTrue: [ self colorForOnlyLocal ]
				ifFalse: [ self colorForAlreadyPushed ])
]

{ #category : #visiting }
RiRepositoryBrowser >> visitTagMark: aRiTagMark [
	^ self
		markMorphText: aRiTagMark name
		icon: self iconForTag
		color: self colorForAlreadyPushed
]

{ #category : #visiting }
RiRepositoryBrowser >> visitWorkingCopyMark: aRiWorkingCopyMark [
	^ self
		markMorphText: 'WORKING COPY'
		icon: self iconForWorkingCopy
		color:
			(aRiWorkingCopyMark workingCopy isModified
				ifTrue: [ self colorForOnlyLocal ]
				ifFalse: [ self colorForAlreadyPushed ])
]
