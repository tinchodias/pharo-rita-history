Class {
	#name : #RiSummaryBrowser,
	#superclass : #RiRepositoryBrowser,
	#category : #'Rita-Summary-UI'
}

{ #category : #examples }
RiSummaryBrowser class >> example1 [

	| repository graph |
	repository := RiRepository new iceRepository: self exampleRepository; process; yourself.
	graph := RiSummaryGraph new
		repository: repository;
		process;
		yourself.
	
	self openWith: graph.
]

{ #category : #examples }
RiSummaryBrowser class >> openWith: graph [

	| dataSource table |
	dataSource := self new.
	
	table := FTTableMorph new
		extent: 500 @ 700;
		addColumn: (FTColumn id: ' ');
		addColumn: (FTColumn id: 'Description');
		dataSource: dataSource;
		beResizable;
		yourself.
	
	dataSource model: graph.
	
	table openInWindowLabeled: 'Summary'
]

{ #category : #accessing }
RiSummaryBrowser >> cellColumn: column row: rowIndex [
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
			addMorphBack: (self descriptionFor: item) asMorph;
			yourself ].

"	column id = 'SHA' ifTrue: [
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
			yourself ]."

	^ self error
]

{ #category : #accessing }
RiSummaryBrowser >> descriptionFor: item [
	^ item commits first shortId asString, ' - ', item commits size asString, ' commits'
]

{ #category : #initialization }
RiSummaryBrowser >> initialize [

	super initialize.
	hiedraColumnController renderer
		nodeColor: Color red;
		linkColor: Color red.
]

{ #category : #accessing }
RiSummaryBrowser >> model: aRiSummaryGraph [

	self elements: aRiSummaryGraph elements
]
