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
			self declareIcebergOn: spec.
			spec
				package: 'Rita-Model';
				package: 'Rita-Tests' with: [ spec requires: #( 'Rita-Model' 'Iceberg' ) ];
				package: 'Rita-Roassal3' with: [ spec requires: #( 'Rita-Model' ) ];
				package: 'Rita-UI' with: [ spec requires: #( 'Rita-Model' 'Rita-Roassal3' ) ] ]
]

{ #category : 'baselines' }
BaselineOfRita >> declareIcebergOn: spec [

	spec baseline: 'Iceberg' with: [
		spec
			repository: 'github://pharo-vcs/iceberg:Pharo14/';
			loads: #(allTests) ]
]
