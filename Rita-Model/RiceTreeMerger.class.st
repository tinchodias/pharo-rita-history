Class {
	#name : 'RiceTreeMerger',
	#superclass : 'Object',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'building' }
RiceTreeMerger >> merge: changeTree into: currentTree [

	^ changeTree collectWithPath: [ :operation :path | 
			currentTree 
				resolve: path 
				ifPresent: [ :currentOperation | operation mergeWithOperation: currentOperation ] 
				ifAbsent: [ RiceNonConflictingOperation operation: operation] ]
]
