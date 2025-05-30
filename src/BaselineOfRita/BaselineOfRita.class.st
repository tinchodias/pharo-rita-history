Class {
	#name : 'BaselineOfRita',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRita',
	#package : 'BaselineOfRita'
}

{ #category : 'baselines' }
BaselineOfRita >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec
			package: 'Rita-Model';
			package: 'Rita-Tests' with: [ spec requires: #('Rita-Model') ];
			package: 'Rita-Roassal3' with: [ spec requires: #('Rita-Model') ];
			package: 'Rita-Avatars' with: [ spec requires: #('Rita-Roassal3') ];
			package: 'Rita-UI' with: [ spec requires: #('Rita-Avatars' 'Rita-Model' 'Rita-Roassal3') ] ]
]
