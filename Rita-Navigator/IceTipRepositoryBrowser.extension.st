Extension { #name : #IceTipRepositoryBrowser }

{ #category : #'*Rita-Navigator' }
IceTipRepositoryBrowser class >> defaultSpec [
	<spec: #default>
	
	^ SpecBoxLayout newVertical
		add: #toolbar withConstraints: [ :c | c height: IceTipToolbar defaultHeight ];
		add: (SpecPanedLayout newHorizontal
			position: 10 percent; 
			add: #sidebarTree;
			add: #historyPanel withConstraints:[ :c | c spec: #panelSpec ];
			yourself);
		yourself
]