"
I am a tree implementation used for diffing and merging.

I work by composition and not inheritance. My users should use the values of the node (kept in the #value instance variable) and not subclass myself.
Each node stores its child nodes in a dictionary, indexed by a key.

Tree API:
 - #/ access to children
 - #path get the path of the current node in the tree
 - #parent get the parent node of the current node
 - #rootNode get the root node of the current tree
 - #children get the children of the current node
 - #keys, #keysDo:, #includesKey: enumerate the keys of the node
 - #at:put, #childAt:ifAbsentPut:, #childAt:ifPresent:
 - #resolve:, #resolve:ifAbsent: resolve a path in the current node
 - #replaceBy: replaces the current node by another node
 - #replace:with: replaces the given child node by another node

Enumerating API:
 - #allSatisfy:
 - #anySatisfy:
 - #collect:
 - #detect:
 - #select:
 - #count:
 - #do:

Visiting API:
 - visit:
"
Class {
	#name : #RiceNode,
	#superclass : #RiceAbstractNode,
	#instVars : [
		'parent',
		'childrenDictionary',
		'value'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceNode class >> value: aValue [
	
	^ self new
		value: aValue;
		yourself
]

{ #category : #'instance creation' }
RiceNode class >> value: aValue parent: aParentNode [ 
	
	^ (self value: aValue)
		parent: aParentNode;
		yourself
]

{ #category : #accessing }
RiceNode >> / aString [ 
	
	^ childrenDictionary at: aString
]

{ #category : #comparing }
RiceNode >> = anotherNode [

	^ (self basicEqualsTo: anotherNode)
		and: [ self children asSet = anotherNode children asSet ]
]

{ #category : #visiting }
RiceNode >> accept: aVisitor [
	
	^ aVisitor visitTreeNode: self
]

{ #category : #adding }
RiceNode >> addChild: aChild [
	
	^ self addNode: (self class value: aChild).
]

{ #category : #adding }
RiceNode >> addNode: aNode [

	self at: aNode key put: aNode.
	^ aNode
]

{ #category : #adding }
RiceNode >> addTo: anotherNode [
	
	anotherNode addNode: self
]

{ #category : #accessing }
RiceNode >> allParentNodes [

	self hasParent ifFalse: [ ^ #() ].
	^ self parent withAllParentNodes

]

{ #category : #accessing }
RiceNode >> allPathSegments [

	^ self withAllParentNodes collect: [ :each | each key ]
]

{ #category : #enumerating }
RiceNode >> allSatisfy: aBlockClosure [ 
	
	(aBlockClosure value: self value)
		ifFalse: [ ^ false ].
		
	self childrenDo: [ :e |
		(e allSatisfy: aBlockClosure)
			ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #enumerating }
RiceNode >> anySatisfy: aBlockClosure [ 
	
	(aBlockClosure value: self value)
		ifTrue: [ ^ true ].
		
	self childrenDo: [ :e |
		(e anySatisfy: aBlockClosure)
			ifTrue: [ ^ true ] ].

	^ false
]

{ #category : #accessing }
RiceNode >> at: aString put: aNode [ 
	
	aNode parent: self.
	childrenDictionary at: aString put: aNode
]

{ #category : #comparing }
RiceNode >> basicEqualsTo: aNode [

	^ self value = aNode value
]

{ #category : #accessing }
RiceNode >> childAt: aString ifAbsentPut: aBlock [

	^ childrenDictionary
		  at: aString
		  ifAbsent: [ self addChild: aBlock value ]
]

{ #category : #accessing }
RiceNode >> childAt: aString ifPresent: aBlockClosure [

	^ childrenDictionary at: aString ifPresent: aBlockClosure
]

{ #category : #accessing }
RiceNode >> children [
	"Answer the children in the order they were added."

	^ childrenDictionary values
]

{ #category : #enumerating }
RiceNode >> collect: aBlock [
	| newNode |
	newNode := self class value: (aBlock value: self value).
	self childrenDo: [ :e |
		newNode addNode: (e collect: aBlock) ].
	^ newNode
]

{ #category : #enumerating }
RiceNode >> collectWithPath: aBlock [
	| newNode |
	newNode := self class value: (aBlock value: self value value: self path).
	self childrenDo: [ :each |
		newNode addNode: (each collectWithPath: aBlock) ].
	^ newNode
]

{ #category : #enumerating }
RiceNode >> count: aBlockClosure [ 
	
	| count |
	count := 0.
	(aBlockClosure value: self value)
		ifTrue: [ count := 1 ].
	
	self childrenDo: [ :each | count := count + (each count: aBlockClosure) ].
	^ count
]

{ #category : #accessing }
RiceNode >> definition [
	
	^ value definition
]

{ #category : #accessing }
RiceNode >> description [
	
	^ value description
]

{ #category : #enumerating }
RiceNode >> detect: aBlock [
	^ (self firstNodeSuchThat: aBlock) value
]

{ #category : #enumerating }
RiceNode >> do: aBlockClosure [ 
	
	aBlockClosure value: self value.
	self childrenDo: [ :node | node do: aBlockClosure ]
]

{ #category : #enumerating }
RiceNode >> firstNodeSuchThat: conditionBlock ifNone: noneBlock [
	
	(conditionBlock value: self)
		ifTrue: [ ^ self ].
	
	self
		nextNodeSuchThat: conditionBlock
		ifFound: [ :found | ^ found ].
	
	^ self parent
		ifNil: noneBlock
		ifNotNil: [
			self parent
				nextChildNodeStartingFrom: self
				suchThat: conditionBlock
				ifNone: noneBlock ]
]

{ #category : #'as yet unclassified' }
RiceNode >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastTable 
		title: 'Items';
		display: [ self children ];
		column: 'Key' evaluated: [:each | each key ] width: 200 * self currentWorld displayScaleFactor;
		column: 'Value' evaluated: [:each | each value ] width: 400 * self currentWorld displayScaleFactor
]

{ #category : #testing }
RiceNode >> hasChanges [
	
	^ value hasChanges or: [ self children anySatisfy: [ :child | child hasChanges ] ]
]

{ #category : #testing }
RiceNode >> hasParent [
	
	^ self parent notNil
]

{ #category : #comparing }
RiceNode >> hash [

	^ self key hash
]

{ #category : #accessing }
RiceNode >> includesKey: anObject [
	
	^ childrenDictionary includesKey: anObject
]

{ #category : #initialization }
RiceNode >> initialize [

	super initialize.
	childrenDictionary := SmallDictionary new
]

{ #category : #testing }
RiceNode >> isEmpty [
	
	^ childrenDictionary isEmpty
]

{ #category : #testing }
RiceNode >> isEmptyNode [

	^ false
]

{ #category : #accessing }
RiceNode >> key [
	
	^ value key
]

{ #category : #accessing }
RiceNode >> keys [

	^ childrenDictionary keys
]

{ #category : #accessing }
RiceNode >> keysDo: aBlockClosure [ 
	
	childrenDictionary keysDo: aBlockClosure
]

{ #category : #enumerating }
RiceNode >> mergeWith: anotherTree onLeft: leftBlock onRight: rightBlock onMerge: mergeBlock [
	
	| mergedTree newNode |
	mergedTree := mergeBlock value: self value value: anotherTree value.
	newNode := self class value: mergedTree.
		
	self keysDo: [ :key |
		(anotherTree includesKey: key)
			ifTrue:  [ | childNode | 
				childNode := (self / key)
					mergeWith: anotherTree / key
					onLeft: leftBlock
					onRight: rightBlock
					onMerge: mergeBlock.
				childNode addTo: newNode ]
			ifFalse: [ 
				newNode addNode: ((self / key) collect: leftBlock) ] ].

	anotherTree keysDo: [ :key |
		(self includesKey: key)
			ifFalse: [ 
				newNode addNode: ((anotherTree / key) collect: rightBlock) ] ].

	^ newNode
]

{ #category : #enumerating }
RiceNode >> mergeWith: anotherTree onMerge: mergeBlock [
	
	^ self
		mergeWith: anotherTree
		onLeft: [ :each | each ]
		onRight:  [ :each | each ]
		onMerge: mergeBlock
]

{ #category : #enumerating }
RiceNode >> nextChildNodeStartingFrom: anIceNode suchThat: conditionBlock ifNone: noneBlock [ 
	
	| aCollection |
	aCollection := self children.
	(aCollection indexOf: anIceNode) + 1
		to: aCollection size do: [ :index | | item |
			item := aCollection at: index.
			(conditionBlock value: item)
				ifTrue: [ ^ item ].
			item
				nextNodeSuchThat: conditionBlock
				ifFound: [ :found | ^ found ] ].
	
	self parent ifNil: [^ noneBlock value ].
	
	^ self parent
		nextChildNodeStartingFrom: self
		suchThat: conditionBlock
		ifNone: noneBlock
]

{ #category : #enumerating }
RiceNode >> nextNodeSuchThat: conditionBlock ifFound: foundBlock [ 
	
	self children do: [ :each |
		(conditionBlock value: each)
			ifTrue: [ ^ foundBlock value: each ].
		each
			nextNodeSuchThat: conditionBlock
			ifFound: [ :found | ^  foundBlock value: found  ] ].
]

{ #category : #enumerating }
RiceNode >> nextNodeSuchThat: conditionBlock ifNone: noneBlock [
	
	self children do: [ :each |
		(conditionBlock value: each)
			ifTrue: [ ^ each ].
		each
			nextNodeSuchThat: conditionBlock
			ifFound: [ :found | ^ found  ] ].
	
	^ self parent
		nextChildNodeStartingFrom: self
		suchThat: conditionBlock
		ifNone: noneBlock
]

{ #category : #accessing }
RiceNode >> parent [
	^ parent
]

{ #category : #accessing }
RiceNode >> parent: anObject [
	
	parent := anObject
]

{ #category : #accessing }
RiceNode >> path [
	
	^ RelativePath withAll: self allPathSegments
]

{ #category : #printing }
RiceNode >> printOn: aStream [
	aStream
		nextPutAll: 'IceNode(';
		nextPutAll: self key asString;
		nextPutAll: ')'
]

{ #category : #removing }
RiceNode >> removeChild: anIceNode [ 
	
	childrenDictionary removeKey: anIceNode key
]

{ #category : #accessing }
RiceNode >> replace: oldNode with: newNode [
	
	self assert: oldNode name = newNode name.
	childrenDictionary at: oldNode name put: newNode
]

{ #category : #accessing }
RiceNode >> replaceBy: aNode [ 
	
	parent replace: self with: aNode
]

{ #category : #accessing }
RiceNode >> resolve: aRelativePath [ 
	
	^ self resolve: aRelativePath ifAbsent: [ NotFound signalFor: aRelativePath ]
]

{ #category : #accessing }
RiceNode >> resolve: aRelativePath ifAbsent: aBlock [
	
	^ self resolve: aRelativePath ifPresent: [ :each | each ] ifAbsent: aBlock
]

{ #category : #accessing }
RiceNode >> resolve: aRelativePath ifPresent: presentBlock ifAbsent: absentBlock [ 	
	| segments node |
	segments := aRelativePath segments.
	
	segments ifEmpty: [ ^ presentBlock value: self value ].
	
	node := childrenDictionary at: segments first ifAbsent: [^ absentBlock value ].
	
	^node
		resolve: (RelativePath withAll: segments allButFirst) 
		ifPresent: presentBlock
		ifAbsent: absentBlock
]

{ #category : #accessing }
RiceNode >> rootNode [
	
	^ self parent rootNode
]

{ #category : #enumerating }
RiceNode >> select: aBlock [

	| selectedChildren newNode |
	selectedChildren := self children collect: [ :childNode | 
		childNode select: aBlock ].
	
	((selectedChildren anySatisfy: [ :each | each isEmptyNode not ])
		or: [ aBlock value: self value ])
			ifFalse: [ ^ RiceEmptyNode new ].
		
	newNode := self class value: self value.
	selectedChildren do: [ :e |
		e addTo: newNode ].
	^ newNode
]

{ #category : #evaluating }
RiceNode >> value [
	
	^ value
]

{ #category : #evaluating }
RiceNode >> value: aValue [
 
	value := aValue
]

{ #category : #accessing }
RiceNode >> withAllParentNodes [

	self hasParent ifFalse: [ ^ #() ].
	self parent hasParent ifFalse: [ ^ { self } ].
	^ self parent withAllParentNodes copyWith: self
]
