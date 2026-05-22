"
I am a Spec2 application to open the Rita root presenter in Morphic backend.
"
Class {
	#name : 'RiSpApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'aesthetics'
	],
	#category : 'Rita-UI-Spec2-Base',
	#package : 'Rita-UI',
	#tag : 'Spec2-Base'
}

{ #category : 'accessing' }
RiSpApplication >> aesthetics [

	^ aesthetics
]

{ #category : 'initialization' }
RiSpApplication >> initialize [

	super initialize.
	self useBackend: #Morphic with: RiSpMorphicConfiguration new.
	aesthetics := RiAestheticsModel new
]

{ #category : 'running' }
RiSpApplication >> start [
	"
	self new start
	"
	
	(self new: RitaBrowserPresenter) open
]
