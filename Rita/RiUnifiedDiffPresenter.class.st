"
I am a copy of class RiDiffSpTextPresenterBuilder. This comment is copied from there, and might not be entirely accurate

I am a copy of class RiDiffSpPresenterBuilder. This comment is copied from there, and might not be entirely accurate

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	lines:		<Object>
	newText:		<Object>
	oldText:		<Object>


    Implementation Points
"
Class {
	#name : #RiUnifiedDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'presenter',
		'colorMap',
		'inlinecolorMap'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiUnifiedDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #presenter;
		yourself
]

{ #category : #initialization }
RiUnifiedDiffPresenter >> initialize [
	super initialize.
	
	colorMap := {
		#insert -> self theme diffAdditionalLineBackgroundColor.
		#remove -> self theme diffRemovedLinesBackgroundColor.
		} asDictionary.
		
	inlinecolorMap := {
		#insert -> self theme diffAdditionalTextInLineBackgroundColor.
		#remove -> self theme diffRemovalHighlightColor.
		} asDictionary 
]

{ #category : #initialization }
RiUnifiedDiffPresenter >> initializePresenters [
	presenter := SpTextPresenter new
		disable;
		yourself.

	"Note: this assumes Morphic backend"
	presenter whenBuiltDo: [ :ann |
		ann widget font: StandardFonts codeFont ].

]

{ #category : #accessing }
RiUnifiedDiffPresenter >> refreshOnModelUpdate [
	| text segments diff |

	diff := RiUnifiedStringDiff new
		oldString: (model at: #from);
		newString: (model at: #to);
		build;
		yourself.
	text := diff unifiedString.
	segments := OrderedCollection new.

	diff lineJoins do: [:each |
		colorMap at: each rawkind ifPresent: [ :color |
			segments add: ((RubPlainSegmentMorph from: each rawfrom to: each rawto)
				color: color;
				yourself).
		] ].

"	diff inlineJoins do: [:each |
		inlinecolorMap at: each rawkind ifPresent: [ :color |
			segments add: ((RubPlainSegmentMorph from: each rawfrom to: each rawto)
				color: color;
				yourself).
		] ].
"	
 	presenter textArea removeAllSegments.
	presenter text: text.
	presenter textArea font: StandardFonts codeFont.
	segments do: [ :each | presenter textArea addSegment: each ].
]

{ #category : #accessing }
RiUnifiedDiffPresenter >> reset [
	model := nil.
	presenter isBuilt ifFalse: [ ^ self ].
	presenter textArea removeAllSegments.
	presenter text: ''.

]
