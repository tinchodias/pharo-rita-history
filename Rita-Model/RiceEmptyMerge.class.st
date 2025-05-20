"
I am a null object representing the absence of a merge. I am used when no merge is needed between two versions, for example, in case the commit to merge is already in the image and the commit to merge into is an ancestor of this commit.
"
Class {
	#name : 'RiceEmptyMerge',
	#superclass : 'Object',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'accessing' }
RiceEmptyMerge >> mergeTree [
	
	^ RiceEmptyNode new
]

{ #category : 'accessing' }
RiceEmptyMerge >> tree [
	
	^ self mergeTree
]
