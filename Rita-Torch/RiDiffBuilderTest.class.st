Class {
	#name : #RiDiffBuilderTest,
	#superclass : #TestCase,
	#category : #'Rita-Torch-Utilities'
}

{ #category : #tests }
RiDiffBuilderTest >> test01AddTwoLinesAtEnd [

	| linesDiff |
	linesDiff := RiDiffBuilder
		from: 'two'
		to: 'two
"Comment"
^2'.

	linesDiff groupedResults equals: { #total -> 3. { #add->(2 to: 3). } }.
]

{ #category : #tests }
RiDiffBuilderTest >> test02AddLinesAtStartAndEnd [

	| linesDiff |
	linesDiff := RiDiffBuilder
		from: '"
two
"'
		to: '"
ONE
ONE
two
ONE
ONE
"'.

	linesDiff groupedResults halt.
]

{ #category : #tests }
RiDiffBuilderTest >> test03ReplaceLines [

	| linesDiff |
	linesDiff := RiDiffBuilder
		from: '"
one
one
one
one
two
"'
		to: '"
ONE
ONE
two
"'.

	linesDiff results.
	1 halt.
]

{ #category : #tests }
RiDiffBuilderTest >> test04RemoveLines [

	| linesDiff |
	linesDiff := RiDiffBuilder
		from: '"
one
one
two
one
one
"'
		to: '"
"'.

	linesDiff groupedResults halt.
]
