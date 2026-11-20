"
I am a scope that stands for a single open pull request of the repository. Selecting me fills the commit table with the pull request commits (from the merge base to its head).
"
Class {
	#name : 'RiPullRequestScope',
	#superclass : 'RiScope',
	#instVars : [
		'pullRequest'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiPullRequestScope class >> pullRequest: aRiPullRequest [

	^ self new
		  pullRequest: aRiPullRequest;
		  yourself
]

{ #category : 'accessing' }
RiPullRequestScope >> elementsIn: aRiRepository [

	^ self pullRequest commits
]

{ #category : 'accessing' }
RiPullRequestScope >> iconName [

	^ #github
]

{ #category : 'accessing' }
RiPullRequestScope >> label [

	^ self pullRequest label
]

{ #category : 'accessing' }
RiPullRequestScope >> pullRequest [

	^ pullRequest
]

{ #category : 'accessing' }
RiPullRequestScope >> pullRequest: aRiPullRequest [

	pullRequest := aRiPullRequest
]
