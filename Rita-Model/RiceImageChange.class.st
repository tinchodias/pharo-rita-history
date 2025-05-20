"
I represent a change coming from the image (in contrast to a change coming from git). I know the changed file and I can be visited to define the create a more detailed diff.
"
Class {
	#name : 'RiceImageChange',
	#superclass : 'RiceChange',
	#instVars : [
		'package'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceImageChange class >> package: anIcePackage [ 
	
	^ self new
		package: anIcePackage;
		yourself
]

{ #category : 'building' }
RiceImageChange >> accept: aVisitor [
	
	^ aVisitor visitImageChange: self
]

{ #category : 'displaying' }
RiceImageChange >> displayingProgressString [
	^ 'Comparing image changes of ' , self package name
]

{ #category : 'accessing' }
RiceImageChange >> package [
	^ package
]

{ #category : 'accessing' }
RiceImageChange >> package: anIcePackage [ 
	package := anIcePackage
]
