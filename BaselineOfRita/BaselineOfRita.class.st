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
			spec baseline: 'Hiedra' with: [
				spec repository: 'github://tinchodias/Hiedra:roassal3/src' ].
			spec
				package: 'Rita';
				package: 'Rita-Navigator';
				package: 'Rita-IceTip' with: [ spec requires: #('Hiedra' 'Rita-Navigator') ].
			spec
				group: 'default' with: #('Rita' 'Rita-IceTip') ]
]
