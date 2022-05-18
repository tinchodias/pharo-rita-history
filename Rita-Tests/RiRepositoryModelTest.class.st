Class {
	#name : #RiRepositoryModelTest,
	#superclass : #RiTestCase,
	#category : #'Rita-Tests'
}

{ #category : #tests }
RiRepositoryModelTest >> testAllAncestors [
	"
	input:

	4 		B
	|
	3
	|\
	| 2   A
	|/
	1

	"
	
	| c1 c2 c3 c4 e1 e2 e3 e4 tagA tagB |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	tagA := self createTag: 'A'.
	c3 := self commitWithMessage: '3' andParents: { c2. c1 }.
	c4 := self commitWithMessage: '4'.
	tagB := self createTag: 'B'.

	self buildRepository.

	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	e3 := repository elementByCommit at: c3.
	e4 := repository elementByCommit at: c4.

	self assert: e1 allAncestors isEmpty.
	self assertCollection: e2 allAncestors hasSameElements: { e1 }.
	self assertCollection: e3 allAncestors hasSameElements: { e2. e1 }.
	self assertCollection: e4 allAncestors hasSameElements: { e3. e2. e1. }.

]

{ #category : #tests }
RiRepositoryModelTest >> testAllChildren [
	"
	input:

	4 		B
	|
	3
	|\
	| 2   A
	|/
	1

	"
	
	| c1 c2 c3 c4 e1 e2 e3 e4 tagA tagB |
	c1 := self commitWithMessage: '1'.
	c2 := self commitWithMessage: '2'.
	tagA := self createTag: 'A'.
	c3 := self commitWithMessage: '3' andParents: { c2. c1 }.
	c4 := self commitWithMessage: '4'.
	tagB := self createTag: 'B'.

	self buildRepository.

	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	e3 := repository elementByCommit at: c3.
	e4 := repository elementByCommit at: c4.

	self assertCollection: e1 allChildren hasSameElements: { e3. e4. e2. }.
	self assertCollection: e2 allChildren hasSameElements: { e3. e4 }.
	self assertCollection: e3 allChildren hasSameElements: { e4 }.
	self assert: e4 allChildren asArray isEmpty.

]

{ #category : #tests }
RiRepositoryModelTest >> testEnsureProcessed [

	repository := RiRepository iceRepository: self repository.
	repository ensureProcessed.
	self assert: repository elements size equals: 0.
	self assert: repository elementMarks size equals: 0.

	self commitWithMessage: '1'.

	"It is not automatically refreshed:"
	self assert: repository elements size equals: 0.
	self assert: repository elementMarks size equals: 0.

	"Refresh:"
	repository reset; ensureProcessed.
	self assert: repository elements size equals: 1.
	self assert: repository elementMarks size equals: 1. "master"

	"Same applies to tags, they need a refresh:"
	self createTag: 'A'.
	self assert: repository elementMarks size equals: 1.
	repository reset; ensureProcessed.
	self assert: repository elementMarks size equals: 2. "master, b"

]

{ #category : #tests }
RiRepositoryModelTest >> testMerge [
	"
	input:

	3 		B
	|\
	| 2
	|/
	1 		A

	"
	
	| c1 c2 c3 e1 e2 e3 |
	c1 := self commitWithMessage: '1'.
	self createTag: 'A'.
	c2 := self commitWithMessage: '2'.
	c3 := self commitWithMessage: '3' andParents: { c2. c1 }.
	self createTag: 'B'.

	self buildRepository.

	self assert: repository elements size equals: 3.
	self assert: repository elementMarks size equals: 3.

	e1 := repository elementByCommit at: c1.
	e2 := repository elementByCommit at: c2.
	e3 := repository elementByCommit at: c3.

	"ancestors"
	self assert: e1 ancestors isEmpty.
	self assert: e2 ancestors equals: { e1 }.
	self assert: e3 ancestors equals: { e2. e1 }.
	
	"children"
	self assert: e1 children equals: { e3. e2 }.
	self assert: e2 children equals: { e3 }.
	self assert: e3 children isEmpty.

]

{ #category : #tests }
RiRepositoryModelTest >> testSimple [
	"
	input:

	3 		A
	|
	2
	|
	1

	"

	self commitWithMessage: '1'.
	self commitWithMessage: '2'.
	self commitWithMessage: '3'.
	self createTag: 'A'.
	
	self buildRepository.

	self assert: repository elements size equals: 3.
	self assert: repository elementMarks size equals: 2.

]
