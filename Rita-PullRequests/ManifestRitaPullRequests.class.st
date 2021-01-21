"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestRitaPullRequests,
	#superclass : #PackageManifest,
	#category : #'Rita-PullRequests-Manifest'
}

{ #category : #'code-critics' }
ManifestRitaPullRequests class >> ruleReGuardClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ZuRubRuler #mouseMove: #false)) #'2021-01-11T08:27:41.363354-03:00') )
]
