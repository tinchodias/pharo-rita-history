Class {
	#name : #RiLinesDiffBuilderTest,
	#superclass : #TestCase,
	#category : #'Rita-Torch-Utilities'
}

{ #category : #tests }
RiLinesDiffBuilderTest >> test01AddTwoLinesAtEnd [

	| linesDiff |
	linesDiff := RiLinesDiffBuilder
		from: 'two'
		to: 'two
"Comment"
^2'.

	linesDiff coolresult equals: { #total -> 3. { #add->(2 to: 3). } }.
]

{ #category : #tests }
RiLinesDiffBuilderTest >> test02AddLinesAtStartAndEnd [

	| linesDiff |
	linesDiff := RiLinesDiffBuilder
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

	linesDiff coolresult halt.
]

{ #category : #tests }
RiLinesDiffBuilderTest >> test03ReplaceLines [

	| linesDiff |
	linesDiff := RiLinesDiffBuilder
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

	linesDiff coolresult halt.
]

{ #category : #tests }
RiLinesDiffBuilderTest >> test04RemoveLines [

	| linesDiff |
	linesDiff := RiLinesDiffBuilder
		from: '"
one
one
two
one
one
"'
		to: '"
"'.

	linesDiff coolresult halt.
]
