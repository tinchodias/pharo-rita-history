"
I am the superclass of the tests of Rita that need a git repository.
Each test gets a new empty Iceberg repository in a temporary folder of the image directory, available through #repository, and it is deleted after the test.
I only rely on the Iceberg that ships with Pharo, not on the Iceberg test packages.
"
Class {
	#name : 'RiTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'repository',
		'iceRepository',
		'location',
		'sharingBetweenImages',
		'credentialsProviderType'
	],
	#category : 'Rita-Iceberg-Tests',
	#package : 'Rita-Iceberg-Tests'
}

{ #category : 'testing' }
RiTestCase class >> isAbstract [

	^ self == RiTestCase
]

{ #category : 'running' }
RiTestCase >> buildRepository [
	repository := (RiIcebergRepository iceRepository: self repository)
		process;
		yourself

]

{ #category : 'running' }
RiTestCase >> checkoutBranch: aString [
	^ self repository checkoutBranch: aString
]

{ #category : 'running' }
RiTestCase >> commitWithMessage: aString [
	^ self repository workingCopy
		commitChanges: self repository workingCopyDiff
		withMessage: aString
		force: true
]

{ #category : 'running' }
RiTestCase >> commitWithMessage: aString andParents: aCollection [ 
	
	| aCommit |
	aCommit := self repository
		commitIndexWithMessage: aString
		andParents: aCollection.

	"After a merge, working copy is detached until a checkout"
	self repository head checkout.
	self deny: self repository workingCopy isDetached.

	^ aCommit
]

{ #category : 'running' }
RiTestCase >> createTag: aString [
	^ self repository createTag: aString
]

{ #category : 'running' }
RiTestCase >> deleteBranch: aString [
	(self repository branchNamed: aString) delete.

	self flag: #todo. "Workaround: without this wait the image is broken after running the whole test suite"
	500 milliSeconds wait.

]

{ #category : 'accessing' }
RiTestCase >> repository [
	"Answer the Iceberg repository of the test"

	^ iceRepository
]

{ #category : 'running' }
RiTestCase >> setUp [

	super setUp.
	sharingBetweenImages := IceLibgitRepository shareRepositoriesBetweenImages.
	IceLibgitRepository shareRepositoriesBetweenImages: false.
	credentialsProviderType := IceCredentialsProvider providerType.
	IceCredentialsProvider providerType: IceNonInteractiveCredentialsProvider.
	location := FileLocator imageDirectory / 'test' / UUID new asString.
	iceRepository := IceRepositoryCreator new
		                 location: location;
		                 subdirectory: '';
		                 createNewRepositoryNamed: 'test-project'
]

{ #category : 'running' }
RiTestCase >> tearDown [

	iceRepository ifNotNil: [ :anIceRepository |
		anIceRepository free.
		Smalltalk garbageCollect ].
	[ location ensureDeleteAll ] on: CannotDeleteFileException do: [ "On Windows the files may still be locked by libgit until they are finalized"
		Smalltalk garbageCollect.
		location ensureDeleteAll ].
	IceCredentialsProvider providerType: credentialsProviderType.
	IceLibgitRepository shareRepositoriesBetweenImages: sharingBetweenImages.
	super tearDown
]
