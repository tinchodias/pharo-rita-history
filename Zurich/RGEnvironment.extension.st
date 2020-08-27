Extension { #name : #RGEnvironment }

{ #category : #'*Zurich' }
RGEnvironment >> zurichBrowseAs: browserTitleString extraEnvironmentPlugin: extraEnvironmentPlugin [
	 | clyEnv clyNavEnv browser |
	self adoptForBrowser.
	clyEnv := ClyRing2Environment new.
	clyEnv environment: self.
	clyEnv name: browserTitleString.

	clyNavEnv := (ClyNavigationEnvironment over: clyEnv)
		addPlugin: ClyDefaultSystemEnvironmentPlugin new;
		addPlugin: extraEnvironmentPlugin;
	   attachToSystem.

	browser := ClyFullBrowser new 
		navigationEnvironment: clyNavEnv;
		addPlugin: ClyStandardBrowserPlugin new.

	^ browser open.
]

{ #category : #'*Zurich' }
RGEnvironment >> zurichBrowseAs: browserTitleString extraPlugin: extraEnvironmentPlugin [
	self flag: #remove
]
