Class {
	#name : #BaselineOfRita,
	#superclass : #BaselineOf,
	#category : #BaselineOfRita
}

{ #category : #baseline }
BaselineOfRita >> baseline: spec [
	<baseline>

	spec for: #'pharo8.x' do: [ self baselineForPharo8: spec ].
	spec for: #'pharo9.x' do: [ self baselineForPharo9: spec ].

]

{ #category : #baseline }
BaselineOfRita >> baselineForPharo8: spec [

	spec baseline: 'Roassal3' with: [
		spec repository: 'github://ObjectProfile/Roassal3:old-text-extent/src' ].
	spec baseline: 'TaskIt' with: [
		spec repository: 'github://sbragagnolo/taskit:v1.1.0' ].
	spec baseline: 'Iceberg' with: [
		spec
			repository: 'github://tinchodias/iceberg:rita2';
			loads: 'development' ].
	spec baseline: 'Hiedra' with: [
		spec repository: 'github://tinchodias/hiedra:v3.0.0/src' ].
	spec baseline: 'Microdown' with: [
		spec repository: 'github://pillar-markup/MicroDown:v1.0.4/src' ].

	spec
		package: 'Rita' with: [ spec requires: #('Roassal3' 'TaskIt' 'Iceberg' 'Hiedra' 'Microdown') ];
		package: 'Rita-Tests' with: [ spec requires: #('Rita') ].
	spec
		group: 'default' with: #('Rita' 'Rita-Tests')
]

{ #category : #baseline }
BaselineOfRita >> baselineForPharo9: spec [

	spec baseline: 'Roassal3' with: [
		spec repository: 'github://ObjectProfile/Roassal3:master/src' ].
	spec baseline: 'TaskIt' with: [
		spec repository: 'github://sbragagnolo/taskit:v1.1.1';
		loads: #(coreTests) ].
	spec baseline: 'Iceberg' with: [
		spec
			repository: 'github://tinchodias/iceberg:rita2';
			loads: 'development' ].

	spec
		package: 'Rita' with: [ spec requires: #('Roassal3' 'TaskIt' 'Iceberg') ];
		package: 'Rita-Tests' with: [ spec requires: #('Rita') ];
		package: 'Rita-PullRequests' with: [ spec requires: #('Rita') ].
	spec
		group: 'default' with: #('Rita' 'Rita-Tests' 'Rita-PullRequests')

]
