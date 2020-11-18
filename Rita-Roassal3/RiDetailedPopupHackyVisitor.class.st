Class {
	#name : #RiDetailedPopupHackyVisitor,
	#superclass : #Object,
	#instVars : [
		'renderer'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitClassDefinition: anIceClassDefinition [

	^ #shapeForClassInExpandedMode:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitDirectoryDefinition: d [

	^ #popupDiffMorphFor:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitExtensionDefinition: anIceExtensionDefinition [

	^ #shapeForClassInExpandedMode:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitFileNode: anIceFileDefinition [

	^ #popupDiffMorphFor:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitMethodNode: anIceMethodDefinition [

	^ #popupDiffMorphFor:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitPackage: anIcePackageDefinition [

	^ #shapeForContentsOfCollapsedPackage:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitPropertyDefinition: anIcePropertyDefinition [

	^ #popupDiffMorphFor:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitTraitDefinition: anIceTraitDefinition [

	^ #shapeForClassInExpandedMode:
]

{ #category : #visiting }
RiDetailedPopupHackyVisitor >> visitVariableDefinition: anIceVariableDefinition [

	^ #popupDiffMorphFor:
]
