Class {
	#name : #RiIceTipSettings,
	#superclass : #Object,
	#category : #'Rita-IceTip'
}

{ #category : #settings }
RiIceTipSettings class >> settingsOn: aBuilder [ 
	<systemsettings>
	
	(aBuilder pickOne: #currentDataSourceClass)
		parent: #Iceberg;
		target: RiIceTipDataSource;
		label: 'Commit list data source';
"		description: 'Select your preferred file format.';"
		domainValues: RiIceTipDataSource dataSourceClassOptions.

]
