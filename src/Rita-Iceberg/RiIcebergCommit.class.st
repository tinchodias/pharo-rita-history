"
I am a RiCommit that reads an IceGitCommit of Iceberg. My author and my committer are libgit signatures: they answer #name, #email and #dateAndTime.
"
Class {
	#name : 'RiIcebergCommit',
	#superclass : 'RiCommit',
	#instVars : [
		'iceGitCommit'
	],
	#category : 'Rita-Iceberg-Repository',
	#package : 'Rita-Iceberg',
	#tag : 'Repository'
}

{ #category : 'instance creation' }
RiIcebergCommit class >> repository: aRiRepository iceGitCommit: anIceCommit [
	^ self basicNew
		initializeWithRepository: aRiRepository iceGitCommit: anIceCommit;
		yourself
]

{ #category : 'accessing' }
RiIcebergCommit >> ancestorIds [

	^ iceGitCommit ancestorIds
]

{ #category : 'accessing' }
RiIcebergCommit >> author [
	^ iceGitCommit libgitCommit author
]

{ #category : 'accessing' }
RiIcebergCommit >> authorEmail [
	^ self author email
]

{ #category : 'accessing' }
RiIcebergCommit >> authorName [
	^ iceGitCommit author
]

{ #category : 'accessing' }
RiIcebergCommit >> checkout [

	iceGitCommit checkout
]

{ #category : 'accessing' }
RiIcebergCommit >> comment [
	^ iceGitCommit comment
]

{ #category : 'accessing' }
RiIcebergCommit >> committer [
	^ iceGitCommit libgitCommit committer
]

{ #category : 'accessing' }
RiIcebergCommit >> committerEmail [
	^ self committer email
]

{ #category : 'accessing' }
RiIcebergCommit >> dateAndTime [
	^ RiDatePrinter new stringFor: iceGitCommit datetime asDate
]

{ #category : 'accessing' }
RiIcebergCommit >> iceGitCommit [
	^ iceGitCommit
]

{ #category : 'accessing' }
RiIcebergCommit >> id [
	^ iceGitCommit id
]

{ #category : 'initialization' }
RiIcebergCommit >> initializeWithRepository: aRiRepository iceGitCommit: anIceGitCommit [

	self initializeWithRepository: aRiRepository.
	iceGitCommit := anIceGitCommit
]

{ #category : 'accessing' }
RiIcebergCommit >> shortId [
	^ iceGitCommit shortId
]
