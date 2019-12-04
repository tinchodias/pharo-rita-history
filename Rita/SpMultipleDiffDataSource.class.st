Class {
	#name : #SpMultipleDiffDataSource,
	#superclass : #SpMorphicTableDataSource,
	#category : #'Rita-FastTable'
}

{ #category : #accessing }
SpMultipleDiffDataSource >> cellColumn: column row: rowIndex [
 
	^ super cellColumn: column row: rowIndex
]

{ #category : #accessing }
SpMultipleDiffDataSource >> rowHeight: rowIndex [
 

	^ 300 "super rowHeight: rowIndex"
]
