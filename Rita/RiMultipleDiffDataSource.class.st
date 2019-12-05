Class {
	#name : #RiMultipleDiffDataSource,
	#superclass : #SpMorphicTableDataSource,
	#category : #'Rita-FastTable'
}

{ #category : #accessing }
RiMultipleDiffDataSource >> cellColumn: column row: rowIndex [

	^ (super cellColumn: column row: rowIndex)
		withTopSeparator;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		yourself
]

{ #category : #accessing }
RiMultipleDiffDataSource >> rowHeight: rowIndex [

	^ (table columns first readObject: (table dataSource elementAt: rowIndex)) height
]
