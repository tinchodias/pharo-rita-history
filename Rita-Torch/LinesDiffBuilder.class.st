Class {
	#name : #LinesDiffBuilder,
	#superclass : #TextDiffBuilder,
	#category : #'Rita-Torch'
}

{ #category : #examples }
LinesDiffBuilder class >> example1 [

| diffs diffsByKind |
diffs := (LinesDiffBuilder from: '
aaa
b
cc
' to: '
aaa
d
e
f
cc
') buildPatchSequence.

diffsByKind := diffs groupedBy: #key.


^ {
(diffsByKind at: #insert) size.
(diffsByKind at: #remove) size.
}

]

{ #category : #private }
LinesDiffBuilder >> split: aString [	
	^ aString lines
]
