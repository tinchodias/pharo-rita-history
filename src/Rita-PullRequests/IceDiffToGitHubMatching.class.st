Class {
	#name : #IceDiffToGitHubMatching,
	#superclass : #Object,
	#instVars : [
		'iceDiff',
		'lineNumberInIceDiff',
		'lineNumberInFile',
		'filePathString',
		'pullRequest',
		'iceNode',
		'changedFile',
		'side'
	],
	#category : #'Rita-PullRequests-Model'
}

{ #category : #adding }
IceDiffToGitHubMatching >> addReviewComment: messageString [

	^ pullRequest
		addReviewComment: messageString
		path: filePathString
		side: (String withAll: side)
		line: lineNumberInFile
]

{ #category : #matching }
IceDiffToGitHubMatching >> calculate [

	| lineAndSideMapping lineAndSide commitToResolve file mapping line |
	self flag: #todo. "Shouldn't do this, or do it elsewhere."
	self assert: (pullRequest repository project fileFormat id = #tonel).
	self assert: iceNode definition isMethodDefinition.

	self calculateChangedFile.

	lineAndSideMapping := iceNode accept: ZuLineAndSideVisitor new.
	lineAndSide := lineAndSideMapping at: lineNumberInIceDiff.
	side := lineAndSide second.
	line := lineAndSide first.

	"I think it should be the opposite but debugging shoowed contrary..."
	commitToResolve := side = #RIGHT
		ifTrue: [ iceDiff sourceVersion ]
		ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: filePathString.
	
	mapping := (RiDiffMapping newForFileReference: file)
			iceNodeLineNumber: line;
			iceNode: iceNode;
			iceDiff: iceDiff; 
			calculateFileLineNumber;
			yourself.

	" :D "
	lineNumberInFile := mapping lineNumber.

]

{ #category : #private }
IceDiffToGitHubMatching >> calculateChangedFile [

	| files |
	files := pullRequest changedFiles.
	filePathString := self pathForChangedFile.
	changedFile := files detect: [ :each |
		each pathString = filePathString ].

]

{ #category : #'accessing output' }
IceDiffToGitHubMatching >> filePathString [
	^ filePathString
]

{ #category : #'accessing output' }
IceDiffToGitHubMatching >> iceDiff [
	^ iceDiff
]

{ #category : #initialization }
IceDiffToGitHubMatching >> iceDiff: anObject [
	iceDiff := anObject
]

{ #category : #initialization }
IceDiffToGitHubMatching >> iceNode: anIceNode [

	iceNode := anIceNode
]

{ #category : #accessing }
IceDiffToGitHubMatching >> lineNumberInFile [
	^ lineNumberInFile
]

{ #category : #accessing }
IceDiffToGitHubMatching >> lineNumberInIceDiff [
	^ lineNumberInIceDiff
]

{ #category : #initialization }
IceDiffToGitHubMatching >> lineNumberInIceDiff: anObject [
	lineNumberInIceDiff := anObject
]

{ #category : #private }
IceDiffToGitHubMatching >> pathForChangedFile [

	| log aMethodDefinition iceNodeWithPackage |
	log := pullRequest repository log.
	aMethodDefinition := iceNode definition.

	"TODO"
	self assert: aMethodDefinition isMethodDefinition.

	iceNodeWithPackage := iceNode withAllParentNodes detect: [ :each | 
		                      each definition isPackageDefinition ].

	^ log
		  fileNameForPackageNamed: iceNodeWithPackage definition name
		  classNamed: aMethodDefinition ownerName
		  isTrait: aMethodDefinition ownerIceDefinition isTraitDefinition
		  isMeta: aMethodDefinition classIsMeta
		  selector: aMethodDefinition name
]

{ #category : #initialization }
IceDiffToGitHubMatching >> pullRequest: anObject [
	pullRequest := anObject
]

{ #category : #accessing }
IceDiffToGitHubMatching >> side [
	^ side
]
