Extension { #name : 'IceRingWorkingCopy' }

{ #category : '*Rita-Tests' }
IceRingWorkingCopy >> modifyBehavior: className with: aBlock [ 

	| behavior |
	behavior := ringEnvironment ask behaviorNamed: className.
	aBlock value: behavior.
	self markAsDirtyPackageNamed: behavior package name
]
