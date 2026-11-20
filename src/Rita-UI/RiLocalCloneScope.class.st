"
I am the scope that shows the whole local clone, without restricting to a branch or a tag.
"
Class {
	#name : 'RiLocalCloneScope',
	#superclass : 'RiScope',
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'accessing' }
RiLocalCloneScope >> iconName [

	^ #folder
]

{ #category : 'accessing' }
RiLocalCloneScope >> label [

	^ 'local clone'
]
