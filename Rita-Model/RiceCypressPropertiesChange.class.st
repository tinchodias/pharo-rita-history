Class {
	#name : #RiceCypressPropertiesChange,
	#superclass : #RiceChange,
	#category : #'Rita-Model-Changes'
}

{ #category : #visiting }
RiceCypressPropertiesChange >> accept: anIceChangeImporter [ 
	
	anIceChangeImporter visitCypressPropertiesChange: self
]

{ #category : #displaying }
RiceCypressPropertiesChange >> displayingProgressString [
	^ 'Comparing Cypress changes'
]
