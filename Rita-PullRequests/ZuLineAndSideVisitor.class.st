Class {
	#name : #ZuLineAndSideVisitor,
	#superclass : #IceTreeVisitor,
	#category : #'Rita-PullRequests-Model'
}

{ #category : #visiting }
ZuLineAndSideVisitor >> visitAddition: anIceAddition [ 
	
	^ Array streamContents: [ :stream |
		1 to: anIceAddition leftContents lineCount "definition linesOfCode" do: [ :index |
			stream nextPut: { index. #RIGHT } ] ]
]

{ #category : #visiting }
ZuLineAndSideVisitor >> visitModification: anIceModification [

	^ ZuLineAndSideMapping new
		  mapFrom: anIceModification rightContents
		  to: anIceModification leftContents
]
