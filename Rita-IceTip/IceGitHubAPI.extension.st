Extension { #name : #IceGitHubAPI }

{ #category : #'*Rita-IceTip' }
IceGitHubAPI >> graphql: aGraphQLString [
	^ self jsonContentsWithValidationDo: [
		| client |
		client := self newGraphQLRequest.
		client 
			entity: (ZnEntity text: ('{ "query" : ', (STON toJsonString: aGraphQLString), ' }'));
			contentType: ZnMimeType applicationJson.
		client
			post;
			response ]
]

{ #category : #'*Rita-IceTip' }
IceGitHubAPI >> newGraphQLRequest [
	^ ZnClient new 
		in: [ :this | 
			this 
				username: self credentials username 
				password: self credentials password ];
			url: 'https://api.github.com/graphql';
			yourself
]
