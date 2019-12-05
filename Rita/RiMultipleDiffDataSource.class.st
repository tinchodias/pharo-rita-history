Class {
	#name : #RiMultipleDiffDataSource,
	#superclass : #SpMorphicTableDataSource,
	#category : #'Rita-FastTable'
}

{ #category : #accessing }
RiMultipleDiffDataSource >> cellColumn: column row: rowIndex [
 
	^ super cellColumn: column row: rowIndex
]

{ #category : #accessing }
RiMultipleDiffDataSource >> rowHeight: rowIndex [
 

	^ 300 "super rowHeight: rowIndex"
]
