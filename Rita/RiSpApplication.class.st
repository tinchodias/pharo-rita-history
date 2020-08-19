"
I am a Spec2 application to open the Rita root presenter in Morphic backend.
"
Class {
	#name : #RiSpApplication,
	#superclass : #SpApplication,
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiSpApplication >> initialize [
	super initialize.
	self useBackend: #Morphic with: RiSpMorphicConfiguration new
]

{ #category : #running }
RiSpApplication >> start [
	"
	self new start
	"
	
	(self new: RiRootPresenter) openWithSpec
]
