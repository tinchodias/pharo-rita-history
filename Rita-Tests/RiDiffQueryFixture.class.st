Class {
	#name : #RiDiffQueryFixture,
	#superclass : #IceMultiplePackageFixture,
	#instVars : [
		'commit2',
		'commit3',
		'commit4',
		'commit1'
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

{ #category : #running }
RiDiffQueryFixture >> setUp [
	super setUp.

	commit1 := repository workingCopy
		createClass: 'A' inPackage: packageName1;
		createMethod: 'one ^1' inClass: 'A';
		createMethod: 'two ^2' inClass: 'A';
"		createMethod: 'three ^3' extendingClass: 'A' inPackage: packageName2;"
		commitWithMessage: '1'.

	commit2 := repository workingCopy
		createClass: 'B' inPackage: packageName1;
		commitWithMessage: '2'.

	commit3 := repository workingCopy
		modifyBehavior: 'A' with: [ :c | c instanceVariables: #(i) ];
		createMethod: 'initialize i:=1' inClass: 'A';
		createMethod: 'one ^i' inClass: 'A';
		commitWithMessage: '3'.

	commit4 := repository workingCopy
		removeBehavior: 'B';
		removeMethod: #initialize fromClass: 'A';
		removeMethod: #one fromClass: 'A';
		modifyBehavior: 'A' with: [ :c | c instanceVariables: #() ];
		commitWithMessage: '4'.

]
