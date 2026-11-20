"
I build, in a given Iceberg repository, a scripted history of 7 commits used by RiDiffQueryTest.
The repository content is written directly as Tonel files and committed through the git index, so no class is created in the image.
The history is: 1 adds class A with two methods in the first package, 2 adds class B, 3 adds an instance variable and methods to A, 4 removes B and some of A, 5 changes the repository properties, 6 adds class C in the second package, 7 adds some plain files.
"
Class {
	#name : 'RiDiffQueryFixture',
	#superclass : 'Object',
	#instVars : [
		'repository',
		'commit1',
		'commit2',
		'commit3',
		'commit4',
		'commit5',
		'commit6',
		'commit7',
		'riRepository',
		'lastCommit'
	],
	#category : 'Rita-Tests',
	#package : 'Rita-Tests'
}

{ #category : 'instance creation' }
RiDiffQueryFixture class >> on: anIceRepository [
	"Answer a fixture whose scripted history is already committed in anIceRepository, an empty repository."

	^ self new
		  repository: anIceRepository;
		  build;
		  yourself
]

{ #category : 'running' }
RiDiffQueryFixture >> build [
	"Commit the skeleton of a Tonel repository with two packages, then the 7 scripted commits"

	self writeFileAt: '.project' with: '{' , String lf , '	''srcDirectory'' : ''''' , String lf , '}'.
	self writeFileAt: '.properties' with: '{' , String lf , '	#format : #tonel' , String lf , '}'.
	{
		self packageName1.
		self packageName2 } do: [ :packageName | self writeFileAt: packageName , '/package.st' with: 'Package { #name : ''' , packageName , ''' }' , String lf ].
	self commitWithMessage: 'Initial commit'.

	"Additions"
	self
		writeClassNamed: 'A'
		inPackage: self packageName1
		instanceVariables: #(  )
		methods: {
			('one' -> '^1').
			('two' -> '^2') }.
	commit1 := self commitWithMessage: '1'.

	"Add a new class"
	self
		writeClassNamed: 'B'
		inPackage: self packageName1
		instanceVariables: #(  )
		methods: #(  ).
	commit2 := self commitWithMessage: '2'.

	"Modify class definition"
	self
		writeClassNamed: 'A'
		inPackage: self packageName1
		instanceVariables: #( 'i' )
		methods: {
			('initialize' -> 'i:=1').
			('one' -> '^i').
			('two' -> '^2') }.
	commit3 := self commitWithMessage: '3'.

	"Removal of slot and methods"
	self removeFileAt: self packageName1 , '/B.class.st'.
	self
		writeClassNamed: 'A'
		inPackage: self packageName1
		instanceVariables: #(  )
		methods: { ('two' -> '^2') }.
	commit4 := self commitWithMessage: '4'.

	"Modify file"
	self writeFileAt: '.properties' with: '{' , String lf , '	''hello'' : ''hola'',' , String lf , '	#format : #tonel' , String lf , '}'.
	commit5 := self commitWithMessage: '5'.

	"Add class in another package"
	self
		writeClassNamed: 'C'
		inPackage: self packageName2
		instanceVariables: #(  )
		methods: #(  ).
	commit6 := self commitWithMessage: '6'.

	"Add some files"
	self writeFileAt: 'README.md' with: '# Title'.
	self writeFileAt: 'resources/a.txt' with: 'content for a'.
	self writeFileAt: 'resources/b.txt' with: 'content for b'.
	commit7 := self commitWithMessage: '7'
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit1 [
	^ commit1
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit2 [
	^ commit2
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit3 [
	^ commit3
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit4 [
	^ commit4
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit5 [
	^ commit5
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit6 [
	^ commit6
]

{ #category : 'accessing' }
RiDiffQueryFixture >> commit7 [
	^ commit7
]

{ #category : 'private' }
RiDiffQueryFixture >> commitWithMessage: aString [

	lastCommit := repository commitIndexWithMessage: aString andParents: (lastCommit ifNil: [ #(  ) ] ifNotNil: [ :commit | { commit } ]).
	^ lastCommit
]

{ #category : 'accessing' }
RiDiffQueryFixture >> packageName1 [

	^ 'RiMockPackage1'
]

{ #category : 'accessing' }
RiDiffQueryFixture >> packageName2 [

	^ 'RiMockPackage2'
]

{ #category : 'private' }
RiDiffQueryFixture >> removeFileAt: pathString [

	| file |
	file := repository location / pathString.
	file ensureDelete.
	repository index addPath: (file relativeTo: repository location)
]

{ #category : 'accessing' }
RiDiffQueryFixture >> repository: anIceRepository [

	repository := anIceRepository
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riCommit1 [

	^ self riRepository commitAtSha: commit1 id
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riCommit2 [

	^ self riRepository commitAtSha: commit2 id
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riCommit5 [

	^ self riRepository commitAtSha: commit5 id
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riCommit6 [

	^ self riRepository commitAtSha: commit6 id
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riCommit7 [

	^ self riRepository commitAtSha: commit7 id
]

{ #category : 'accessing' }
RiDiffQueryFixture >> riRepository [

	^ riRepository ifNil: [
		riRepository := RiIcebergRepository iceRepository: repository.
		riRepository process.
		riRepository ]

]

{ #category : 'private' }
RiDiffQueryFixture >> tonelClassNamed: className inPackage: packageName instanceVariables: instanceVariableNames methods: selectorsAndBodies [

	^ String streamContents: [ :stream |
		  stream
			  << 'Class {';
			  lf.
		  (stream tab << '#name : ''' << className)
			  << ''',';
			  lf.
		  stream tab
			  << '#superclass : ''Object'',';
			  lf.
		  instanceVariableNames ifNotEmpty: [
			  stream tab
				  << '#instVars : [';
				  lf.
			  instanceVariableNames do: [ :name |
				  stream
					  tab;
					  tab.
				  (stream << '''' << name)
					  << '''';
					  lf ].
			  stream tab
				  << '],';
				  lf ].
		  (stream tab << '#category : ''' << packageName)
			  << ''',';
			  lf.
		  (stream tab << '#package : ''' << packageName)
			  << '''';
			  lf.
		  stream
			  << '}';
			  lf.
		  selectorsAndBodies do: [ :each |
			  stream lf.
			  stream
				  << '{ #category : ''as yet unclassified'' }';
				  lf.
			  (stream << className << ' >> ' << each key << ' [ ')
				  << each value;
				  lf.
			  stream
				  << ']';
				  lf ] ]
]

{ #category : 'private' }
RiDiffQueryFixture >> writeClassNamed: className inPackage: packageName instanceVariables: instanceVariableNames methods: selectorsAndBodies [

	self writeFileAt: packageName , '/' , className , '.class.st' with: (self
		 tonelClassNamed: className
		 inPackage: packageName
		 instanceVariables: instanceVariableNames
		 methods: selectorsAndBodies)
]

{ #category : 'private' }
RiDiffQueryFixture >> writeFileAt: pathString with: aString [

	| file |
	file := repository location / pathString.
	file ensureCreateFile writeStreamDo: [ :stream | stream << aString ].
	repository index addPath: (file relativeTo: repository location)
]
