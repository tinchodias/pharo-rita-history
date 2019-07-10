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
			spec baseline: 'HiedraRS3' with: [
				spec repository: 'github://tinchodias/Hiedra:roassal3/src' ].
			spec
				package: 'Rita';
				package: 'Rita-Navigator';
				package: 'Rita-IceTip' with: [ spec requires: #('HiedraRS3' 'Rita-Navigator') ].
			spec
				group: 'default' with: #('Rita' 'Rita-IceTip') ]
]
