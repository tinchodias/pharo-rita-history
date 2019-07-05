Class {
	#name : #RiIceTipDataSource,
	#superclass : #IceTipDataSource,
	#instVars : [
		'hiedraColumnController',
		'commitById'
	],
	#classVars : [
		'CurrentDataSourceClass'
	],
	#category : #'Rita-IceTip'
}

{ #category : #accessing }
RiIceTipDataSource class >> beCurrentDataSourceClass [
	CurrentDataSourceClass := self
]

{ #category : #accessing }
RiIceTipDataSource class >> currentDataSourceClass [
	^ CurrentDataSourceClass ifNil: [ IceTipHiedraDataSource ]
]

{ #category : #accessing }
RiIceTipDataSource class >> currentDataSourceClass: aClass [
	CurrentDataSourceClass := aClass
]

{ #category : #accessing }
RiIceTipDataSource class >> dataSourceClassOptions [
	^ {IceTipHiedraDataSource}, RiIceTipAvatarsDataSource subclasses
]

{ #category : #'instance creation' }
RiIceTipDataSource class >> newCurrentDataSource [
	^ self currentDataSourceClass new
]

{ #category : #accessing }
RiIceTipDataSource class >> resetCurrentDataSourceClass [
	CurrentDataSourceClass := nil
]

{ #category : #accessing }
RiIceTipDataSource >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view. I will probably return a FTCellMorph."
	
	column id = ' ' ifTrue: [ 
		^ FTCellMorph new
			addMorphBack: (hiedraColumnController cellMorphAtRow: rowIndex);
			yourself
		].
	
	^ super cellColumn: column row: rowIndex
]

{ #category : #accessing }
RiIceTipDataSource >> elements: commits [

	super elements: commits.

	self table ifNil: [ ^self ].
	
	"Adjust the ruler rendering settings with table's row height."
	hiedraColumnController
		rowHeight: self table rowHeight floor;
		onChangeDo: [ self table changed ].

	"Create a new ruler model with the new elements"
	self refreshRulerWithCurrentElements.

	"Reset the visualization"
	hiedraColumnController reset.
	
	"Adjust the column width in the table"
	self table columns first width: hiedraColumnController rulerWidth.

]

{ #category : #initialization }
RiIceTipDataSource >> initialize [
	
	super initialize.

	hiedraColumnController := HiRS3ColumnController new.
]

{ #category : #private }
RiIceTipDataSource >> refreshRulerWithCurrentElements [

	commitById := Dictionary new.
	elements do: [ :aCommit |
		"Note: Hiedra expects each ancestor id corresponds to a commit in elements."
		commitById
			at: aCommit id
			put: aCommit entity ].

	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: (elements collect: #id)
		linksBlock: [ :id | (commitById at: id) ancestorIds ]).

	hiedraColumnController table: self table.

]
