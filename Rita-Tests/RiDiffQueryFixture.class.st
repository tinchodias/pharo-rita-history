Class {
	#name : #RiDiffQueryFixture,
	#superclass : #IceMultiplePackageFixture,
	#instVars : [
		'commit2',
		'commit3',
		'commit4',
		'commit1',
		'commit5',
		'commit6'
	],
	#category : #'Rita-Tests'
}

{ #category : #accessing }
RiDiffQueryFixture >> commit1 [
	^ commit1
]

{ #category : #accessing }
RiDiffQueryFixture >> commit2 [
	^ commit2
]

{ #category : #accessing }
RiDiffQueryFixture >> commit3 [
	^ commit3
]

{ #category : #accessing }
RiDiffQueryFixture >> commit4 [
	^ commit4
]

{ #category : #accessing }
RiDiffQueryFixture >> commit5 [
	^ commit5
]

{ #category : #accessing }
RiDiffQueryFixture >> commit6 [
	^ commit6
]

{ #category : #running }
RiDiffQueryFixture >> setUp [
	super setUp.

	"Additions"
	commit1 := repository workingCopy
		createClass: 'A' inPackage: packageName1;
		createMethod: 'one ^1' inClass: 'A';
		createMethod: 'two ^2' inClass: 'A';
		commitWithMessage: '1'.

	"Add a new class"
	commit2 := repository workingCopy
		createClass: 'B' inPackage: packageName1;
		commitWithMessage: '2'.

	"Modify class definition"
	commit3 := repository workingCopy
		modifyBehavior: 'A' with: [ :c | c instanceVariables: #(i) ];
		createMethod: 'initialize i:=1' inClass: 'A';
		createMethod: 'one ^i' inClass: 'A';
		commitWithMessage: '3'.

	"Removal of slot and methods"
	commit4 := repository workingCopy
		removeBehavior: 'B';
		removeMethod: #initialize fromClass: 'A';
		removeMethod: #one fromClass: 'A';
		modifyBehavior: 'A' with: [ :c | c instanceVariables: #() ];
		commitWithMessage: '4'.

	"Modify file"
	repository properties at: 'hello' put: 'hola'.
	commit5 := repository workingCopy commitWithMessage: '5'.

	"Add class in another package"
	commit6 := repository workingCopy
		createClass: 'C' inPackage: packageName2;
		commitWithMessage: '6'.

]
