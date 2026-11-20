"
I am the scope that restricts the displayed commits to a branch, represented by a RiBranchMark.
"
Class {
	#name : 'RiBranchScope',
	#superclass : 'RiScope',
	#instVars : [
		'branchMark'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiBranchScope class >> branchMark: aRiBranchMark [

	^ self new branchMark: aRiBranchMark
]

{ #category : 'accessing' }
RiBranchScope >> branchMark [

	^ branchMark
]

{ #category : 'accessing' }
RiBranchScope >> branchMark: aRiBranchMark [

	branchMark := aRiBranchMark
]

{ #category : 'accessing' }
RiBranchScope >> iconName [

	^ #branch
]

{ #category : 'accessing' }
RiBranchScope >> label [

	^ branchMark isOnlyLocal
		  ifTrue: [ branchMark shortname ]
		  ifFalse: [ branchMark remote remoteName , '/' , branchMark shortname ]
]

{ #category : 'accessing' }
RiBranchScope >> mark [

	^ branchMark
]
