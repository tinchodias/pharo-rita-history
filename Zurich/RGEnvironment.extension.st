Extension { #name : #RGEnvironment }

{ #category : #'*Zurich' }
RGEnvironment >> zurichBrowseAs: arg1 extraEnvironmentPlugin: arg2 [
	| tmp1 tmp2 tmp3 tmp5 tmp7 |
	self adoptForBrowser.
	tmp1 := ClyRing2Environment new.
	tmp1
		environment: self;
		name: arg1.
	tmp5 := ClyNavigationEnvironment over: tmp1.
	tmp5
		addPlugin: ClyDefaultSystemEnvironmentPlugin new;
		addPlugin: arg2.
	tmp2 := tmp5 attachToSystem.
	tmp7 := ClyFullBrowser new.
	tmp7 navigationEnvironment: tmp2.
	tmp3 := tmp7 addPlugin: ClyStandardBrowserPlugin new.
	^ tmp3 open
]

{ #category : #'*Zurich' }
RGEnvironment >> zurichBrowseAs: arg1 extraPlugin: arg2 [
	self flag: #remove
]
