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
				spec repository: 'github://sbragagnolo/taskit:v1.1.0' ].
			spec baseline: 'Iceberg' with: [
				spec
					repository: 'github://tinchodias/iceberg:playing';
					loads: 'development' ].
			spec baseline: 'Hiedra' with: [
				spec repository: 'github://tinchodias/hiedra:master/src' ].
			spec baseline: 'Microdown' with: [
				spec repository: 'github://pillar-markup/MicroDown:master/src' ].

			spec
				package: 'Rita' with: [ spec requires: #('Roassal3' 'TaskIt' 'Iceberg' 'Hiedra' 'Microdown') ];
				package: 'Rita-Tests' with: [ spec requires: #('Rita') ].
			spec
				group: 'default' with: #('Rita' 'Rita-Tests') ]
]
