Class {
	#name : 'RiPinDiffModel',
	#superclass : 'RiDiffModel',
	#instVars : [
		'sourceRiElement'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiPinDiffModel class >> sourceRiElement: aRiElement [

	^ self basicNew
		initializeWith: aRiElement;
		yourself
]

{ #category : 'accessing' }
RiPinDiffModel >> iceDiffFrom: targetRiElement [

	^ targetRiElement diffTo: sourceRiElement asIceObject
]

{ #category : 'accessing' }
RiPinDiffModel >> icon [
	^ self iconNamed: #breakpoint
]

{ #category : 'accessing' }
RiPinDiffModel >> initializeWith: aRiElement [

	self initialize.
	sourceRiElement := aRiElement
]

{ #category : 'testing' }
RiPinDiffModel >> shouldCompareTo: aRiElement [
	^ sourceRiElement ~= aRiElement
]

{ #category : 'accessing' }
RiPinDiffModel >> sourceRiElement [
	^ sourceRiElement
]

{ #category : 'accessing' }
RiPinDiffModel >> title [
	^ 'Diff to Pin (', sourceRiElement shortId, ')'
]
