"
I am the scope that restricts the displayed commits to a release: the tag represented by my RiTagMark, plus the commits down to (but excluding) the previous release (the newest tagged ancestor of the tag's commit, see `RiRepository>>previousReleaseElementOf:`).
"
Class {
	#name : 'RiTagScope',
	#superclass : 'RiScope',
	#instVars : [
		'tagMark'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiTagScope class >> tagMark: aRiTagMark [

	^ self new tagMark: aRiTagMark
]

{ #category : 'accessing' }
RiTagScope >> elementsIn: aRiRepository [
	"Answer the elements of aRiRepository in my release range: my tag's commit and its ancestors, down to but excluding the previous release (its newest tagged ancestor) and its ancestors.
	When my tag has no previous release, answer all its ancestors down to the root."

	^ aRiRepository elementsFrom: self tagMark element downTo: (aRiRepository previousReleaseElementOf: self tagMark element)
]

{ #category : 'accessing' }
RiTagScope >> iconName [

	^ #breakpoint
]

{ #category : 'accessing' }
RiTagScope >> iconTransform [

	^ #horizontal
]

{ #category : 'accessing' }
RiTagScope >> label [

	^ tagMark name
]

{ #category : 'accessing' }
RiTagScope >> mark [

	^ tagMark
]

{ #category : 'accessing' }
RiTagScope >> tagMark [

	^ tagMark
]

{ #category : 'accessing' }
RiTagScope >> tagMark: aRiTagMark [

	tagMark := aRiTagMark
]
