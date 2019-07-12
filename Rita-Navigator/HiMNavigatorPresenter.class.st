Class {
	#name : #HiMNavigatorPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'viewPresenter',
		'searchPresenter'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #initialization }
HiMNavigatorPresenter >> fill: aRSView [

	| aHiMNavigator |
	aHiMNavigator := HiMNavigator newOn: aRSView.
	HiMImageDependenciesBuilder new
		navigator: aHiMNavigator;
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. "'Random-Core'"". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build.

]

{ #category : #initialization }
HiMNavigatorPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter.
	viewPresenter script: [ :view | self fill: view ].
	
	searchPresenter := self instantiate: HiMSearchPresenter.
]
