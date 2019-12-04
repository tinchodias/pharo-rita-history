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
			spec baseline: 'TaskIt' with: [
				spec repository: 'github://sbragagnolo/taskit:v1.0' ].

			spec
				package: 'Rita' with: [ spec requires: #('Roassal3' 'TaskIt') ];
				package: 'Rita-Tests' with: [ spec requires: #('Rita') ].
			spec
				group: 'default' with: #('Rita' 'Rita-Tests') ]
]
