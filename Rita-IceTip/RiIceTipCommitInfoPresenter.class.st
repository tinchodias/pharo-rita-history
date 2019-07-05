Class {
	#name : #RiIceTipCommitInfoPresenter,
	#superclass : #IceTipCommitInfoPresenter,
	#instVars : [
		'visualDiffToAncestorPage',
		'visualDiffToHeadPage',
		'packageColorScale'
	],
	#category : #'Rita-IceTip'
}

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> initializeCommitPanel [
	"This will be initialised in fact on the first refresh"

	super initializeCommitPanel.

	packageColorScale := TSScale category20.

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Classes';
			presenterProvider: [ self umlDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Packages';
			presenterProvider: [ self packageDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Multi (Floating)';
			presenterProvider: [ self multigranularFloatingLabelsDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Multi (Top)';
			presenterProvider: [ self multigranularTopLabelDiffFromHeadPresenter ];
			yourself).

]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> labelShapeBuilder [
	^ RiUMLDiffUtils new shapeForClassOrTrait
		scaleBy: 0.2;
		yourself
]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> multigranularFloatingLabelsDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RiMultigranularDiffPresenter)
			labelStrategy: (HiMFloatingLabelStrategy new shapeBuilder: self labelShapeBuilder; yourself);
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> multigranularTopLabelDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RiMultigranularDiffPresenter)
			labelStrategy: (HiMTopLabelStrategy new shapeBuilder: self labelShapeBuilder; yourself);
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> packageDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RiPackageDiffPresenter)
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> umlDiffFromAncestorPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RiClassDiffPresenter)
			diffPresenter: self diffFromAncestor;
			packageColorScale: packageColorScale;
			iceDiffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
RiIceTipCommitInfoPresenter >> umlDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RiClassDiffPresenter)
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]
