"
I am a class that listens to system events and dispatch them to the right iceberg object.
I'm mainly used to mark as dirty packages whose methods and classes are modified.

I'm implemented as class side methods to avoid memory leaks and problems when unsubscribing to events.
"
Class {
	#name : 'RiceSystemEventListener',
	#superclass : 'Object',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'event handling' }
RiceSystemEventListener class >> handleClassChange: aClassChange [

	"We should take care not only about the class package but also the package of the methods extending that class."
	self handlePackagesChange: aClassChange packagesAffected

]

{ #category : 'event handling' }
RiceSystemEventListener class >> handleMethodChange: aMethodChange [

	self handlePackagesChange: aMethodChange packagesAffected
]

{ #category : 'event handling' }
RiceSystemEventListener class >> handlePackageChange: aPackageChange [

	self handlePackagesChange: aPackageChange packagesAffected
]

{ #category : 'event handling' }
RiceSystemEventListener class >> handlePackagesChange: packages [

	IceRepository registry do: [ :repository | | changed |
		changed := false.
		packages do: [ :each | changed := changed | (each isNotNil and: [ repository notifyPackageModified: each name ]) ].
		changed ifTrue: [ 	Iceberg announcer announce: (IceRepositoryModified for: repository) ]]
]

{ #category : 'event handling' }
RiceSystemEventListener class >> handleVersionLoaded: ann [
	"When monticello finishes to load a package, we need to verify its status to mark them as dirty or 
	 not dirty as they apply."

	| package |
	"this is ugly, but since I do not have a package I need to look for it"
	package := RPackageOrganizer default packageMatchingExtensionName: ann label.
	
	"The package can be nil".
	package ifNil: [ ^self ].

	"now we can verify its status"
	RPackageSet withoutCacheDo: [
		IceRepository registry
			do: [ :each | 
				(each includesPackageNamed: package name)
					ifTrue: [ | icePackage isDirty |
						icePackage := each packageNamed: package name.
						self flag: #pharoTodo. "Ugly hack. Should enhance for next version"
						isDirty := each workingCopy referenceCommit isUnknownCommit
							ifTrue: [ true ]
							ifFalse: [ | diff |
								diff := each workingCopy referenceCommit diffToWorkingCopyForPackage: icePackage.
								diff includesPackageNamed: package name ].
						icePackage beDirty: isDirty.
						Iceberg announcer announce: (IceRepositoryModified for: each) ] ]]
]

{ #category : 'class initialization' }
RiceSystemEventListener class >> initialize [

	self registerSystemAnnouncements
]

{ #category : 'class initialization' }
RiceSystemEventListener class >> registerSystemAnnouncements [

	self unregisterSystemAnnouncements.

	self codeChangeAnnouncer weak
		when: ClassAnnouncement send: #handleClassChange: to: self;
		when: MethodAnnouncement send: #handleMethodChange: to: self;
		when: PackageTagAnnouncement send: #handlePackageChange: to: self.

	self codeSupportAnnouncer weak when: MCVersionLoaderStopped send: #handleVersionLoaded: to: self
]

{ #category : 'class initialization' }
RiceSystemEventListener class >> unregisterSystemAnnouncements [
	
	SystemAnnouncer uniqueInstance unsubscribe: self
]
