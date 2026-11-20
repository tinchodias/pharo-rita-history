"
I wrap an IceGitHubPullRequest together with the RiRepository and GitHub remote it belongs to, so Rita can review it. I fetch the pull request head from GitHub, locate its merge base with the base commit, and answer the commits of that range and the cumulative diff between them.
"
Class {
	#name : 'RiPullRequest',
	#superclass : 'Object',
	#instVars : [
		'iceGitHubPullRequest',
		'riRepository',
		'remote',
		'fetched',
		'headCommit',
		'mergeBaseCommit'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiPullRequest class >> from: anIceGitHubPullRequest repository: aRiRepository remote: anIceRemote [

	^ self new
		  iceGitHubPullRequest: anIceGitHubPullRequest;
		  riRepository: aRiRepository;
		  remote: anIceRemote;
		  yourself
]

{ #category : 'accessing' }
RiPullRequest >> author [

	^ self iceGitHubPullRequest author
]

{ #category : 'accessing' }
RiPullRequest >> baseLabel [

	^ self iceGitHubPullRequest baseLabel
]

{ #category : 'accessing' }
RiPullRequest >> baseSHA [

	^ self iceGitHubPullRequest baseSHA
]

{ #category : 'accessing' }
RiPullRequest >> commits [
	"Answer the RiCommits of my range (merge base excluded), newest first, with ancestors and children wired among them, and the merge base wired as the boundary ancestor of the oldest commit."

	| walk riCommits riCommitByIceCommit |
	self fetchHead.

	walk := self riRepository iceRepository newCommitWalk.
	walk revwalk
		beSortedByCommitTime;
		beSortedParentsBeforeChildren.

	walk fromCommit: self headCommit.
	walk uptoCommit: self mergeBaseCommit.

	riCommitByIceCommit := Dictionary new.
	riCommitByIceCommit at: self mergeBaseCommit put: (RiCommit repository: self riRepository iceGitCommit: self mergeBaseCommit).
	riCommits := OrderedCollection new.

	"First we create all ri commits, then close the walk even if one of them fails"
	[
		walk commitsDo: [ :iceCommit |
				| riCommit |
				riCommit := RiCommit repository: self riRepository iceGitCommit: iceCommit.
				riCommitByIceCommit at: iceCommit put: riCommit.
				riCommits add: riCommit ] ] ensure: [ walk close ].

	"Then we associate the ancestors"
	riCommits do: [ :riCommit |
			riCommit iceGitCommit ancestors do: [ :iceAncestor |
					riCommitByIceCommit at: iceAncestor ifPresent: [ :ancestorRiCommit |
							riCommit addAncestor: ancestorRiCommit.
							ancestorRiCommit addChildren: riCommit ] ] ].

	^ riCommits
]

{ #category : 'accessing' }
RiPullRequest >> diff [

	^ RiceDiff from: self headCommit to: self mergeBaseCommit
]

{ #category : 'actions' }
RiPullRequest >> fetchHead [
	"Fetch my head into a local tracking ref so its objects are available for walking and diffing.
	I use GitHub's refs/pull/<N>/head on my remote, which is fork-safe."

	fetched ifTrue: [ ^ self ].
	self remote doFetchWithRefSpec: ('refs/pull/{1}/head:refs/remotes/{2}/pull/{1}/head' format: {
				 self number.
				 self remote name }).
	fetched := true
]

{ #category : 'accessing' }
RiPullRequest >> headCommit [

	^ headCommit ifNil: [
			  self fetchHead.
			  headCommit := self riRepository iceRepository revparse: self headSHA ]
]

{ #category : 'accessing' }
RiPullRequest >> headLabel [

	^ self iceGitHubPullRequest headLabel
]

{ #category : 'accessing' }
RiPullRequest >> headSHA [

	^ self iceGitHubPullRequest headSHA
]

{ #category : 'accessing' }
RiPullRequest >> htmlUrl [

	^ self iceGitHubPullRequest htmlUrl
]

{ #category : 'accessing' }
RiPullRequest >> iceGitHubPullRequest [

	^ iceGitHubPullRequest
]

{ #category : 'accessing' }
RiPullRequest >> iceGitHubPullRequest: anIceGitHubPullRequest [

	iceGitHubPullRequest := anIceGitHubPullRequest
]

{ #category : 'initialization' }
RiPullRequest >> initialize [

	super initialize.
	fetched := false
]

{ #category : 'accessing' }
RiPullRequest >> label [

	^ '#{1} {2}' format: {
			  self number.
			  self title }
]

{ #category : 'accessing' }
RiPullRequest >> mergeBaseCommit [

	^ mergeBaseCommit ifNil: [
			  self fetchHead.
			  mergeBaseCommit := self riRepository iceRepository revparse: (self riRepository iceRepository mergeBaseBetween: self headSHA and: self baseSHA) ]
]

{ #category : 'accessing' }
RiPullRequest >> number [

	^ self iceGitHubPullRequest number
]

{ #category : 'accessing' }
RiPullRequest >> remote [

	^ remote
]

{ #category : 'accessing' }
RiPullRequest >> remote: anIceRemote [

	remote := anIceRemote
]

{ #category : 'accessing' }
RiPullRequest >> riRepository [

	^ riRepository
]

{ #category : 'accessing' }
RiPullRequest >> riRepository: aRiRepository [

	riRepository := aRiRepository
]

{ #category : 'accessing' }
RiPullRequest >> state [

	^ self iceGitHubPullRequest state
]

{ #category : 'accessing' }
RiPullRequest >> title [

	^ self iceGitHubPullRequest title
]
