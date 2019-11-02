Class {
	#name : #RiLinesDiffBuilderTest,
	#superclass : #TestCase,
	#category : #'Rita-Torch-Utilities'
}

{ #category : #tests }
RiLinesDiffBuilderTest >> test01OneLineAdded [

	| linesDiff |
	linesDiff := RiLinesDiffBuilder
		from: 'two'
		to: 'two
"Comment"
^2'.

	linesDiff result halt.
]
