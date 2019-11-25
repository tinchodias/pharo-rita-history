Class {
	#name : #BaselineOfRita,
	#superclass : #BaselineOf,
	#category : #BaselineOfRita
}

{ #category : #baseline }
BaselineOfRita >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [
			spec baseline: 'Roassal3' with: [
				spec repository: 'github://ObjectProfile/Roassal3:master/src' ].
			spec
				package: 'Rita' with: [ spec requires: #('Roassal3') ];
				package: 'Rita-Tests' with: [ spec requires: #('Rita') ].
			spec
				group: 'default' with: #('Rita' 'Rita-Tests') ]
]
