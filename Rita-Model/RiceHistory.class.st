"
I provide optimized access to the history of a commitish. I access the history of a commit in a batch, caching them in an internal collection to provide fast access.

Moreover, I implement fast access to history information such as knowing if a commit is merged in head or not.

Future optimizations: 
 - implement pagination
"
Class {
	#name : #RiceHistory,
	#superclass : #Object,
	#instVars : [
		'commitish',
		'commits',
		'commitDictionary',
		'headHistory',
		'repository'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceHistory class >> on: commitish repository: anIceRepository [
	
	^ self new
		commitish: commitish;
		repository: anIceRepository;
		yourself
]

{ #category : #history }
RiceHistory >> commitDictionary [

	commitDictionary ifNil: [ self lookupCommits ].
	^ commitDictionary
]

{ #category : #accessing }
RiceHistory >> commitish: aCommitish [
	commitish := aCommitish
]

{ #category : #history }
RiceHistory >> commits [
	
	commits ifNil: [ self lookupCommits ].
	^ commits
]

{ #category : #accessing }
RiceHistory >> headHistory [
	
	^ headHistory ifNil: [ 
		headHistory := RiceHistory on: repository headCommit repository: repository ]
]

{ #category : #testing }
RiceHistory >> includes: anIceGitCommit [ 
	
	^ self commitDictionary includesKey: anIceGitCommit id
]

{ #category : #testing }
RiceHistory >> isHead [
	
	^ commitish = repository head
]

{ #category : #history }
RiceHistory >> lookupCommits [
	
	| newCommitDictionary newCommits |
	newCommitDictionary := Dictionary new.
	newCommits := OrderedCollection new.
	commitish commitsDo: [ :each | | commit |
		commit := RiceHistoryCommit commit: each history: self.
		newCommits add: commit.
		newCommitDictionary at: each id put: commit ].
	commitDictionary := newCommitDictionary.
	commits := newCommits.
]

{ #category : #accessing }
RiceHistory >> name [
	
	^ commitish name
]

{ #category : #accessing }
RiceHistory >> repository: aRepository [ 
	repository := aRepository
]
