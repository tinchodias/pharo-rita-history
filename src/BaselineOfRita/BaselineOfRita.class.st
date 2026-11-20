Class {
	#name : 'BaselineOfRita',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRita',
	#package : 'BaselineOfRita'
}

{ #category : 'baselines' }
BaselineOfRita >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'Rita-Model';
			package: 'Rita-Iceberg' with: [ spec requires: #( 'Rita-Model' ) ];
			package: 'Rita-Tests' with: [ spec requires: #( 'Rita-Model' 'Rita-Iceberg' ) ];
			package: 'Rita-Roassal3' with: [ spec requires: #( 'Rita-Model' ) ];
			package: 'Rita-UI' with: [ spec requires: #( 'Rita-Model' 'Rita-Iceberg' 'Rita-Roassal3' ) ] ]
]
