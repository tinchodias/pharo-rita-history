"
I am a basic presenter for widgets in roassal with the Spec system
"
Class {
	#name : #Spec1RoassalPresenter,
	#superclass : #AbstractWidgetPresenter,
	#instVars : [
		'script'
	],
	#category : #'Rita-Torch-Old'
}

{ #category : #specs }
Spec1RoassalPresenter class >> adapterName [
	^ #RSMorphicAdapter
]

{ #category : #specs }
Spec1RoassalPresenter class >> defaultSpec [
	<spec>
	
	^ #(RSMorphicAdapter
		adapt: #(model))
]

{ #category : #initialization }
Spec1RoassalPresenter >> initialize [
	super initialize.
	script := [ :v | ] asValueHolder.
	script whenChangedDo: [ :s | self refresh ].
]

{ #category : #initialization }
Spec1RoassalPresenter >> refresh [ 
	self changed: #applyScript with: #()
]

{ #category : #initialization }
Spec1RoassalPresenter >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #initialization }
Spec1RoassalPresenter >> script [
	^ script value
]

{ #category : #initialization }
Spec1RoassalPresenter >> script: anObject [
	script value: anObject
]
