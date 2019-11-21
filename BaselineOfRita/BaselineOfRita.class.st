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
			spec baseline: 'Roassal3' with: [
					spec repository: 'github://ObjectProfile/Roassal3/src' ].

			spec
				package: 'Rita';
				package: 'Rita-Navigator';
				package: 'Rita-Torch' with: [ spec requires: #('Roassal3') ];
				package: 'Rita-IceTip' with: [ spec requires: #('Hiedra' 'Rita-Navigator' 'Rita-Torch') ].
			spec
				group: 'default' with: #('Rita' 'Rita-Navigator' "'Rita-IceTip'" 'Rita-Torch') ]
]
