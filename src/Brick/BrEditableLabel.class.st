Class {
	#name : #BrEditableLabel,
	#superclass : #BrEditor,
	#instVars : [
		'labelInteractions',
		'editorInteractions'
	],
	#category : #'Brick-Editor - UI'
}

{ #category : #'api - editor' }
BrEditableLabel >> acceptEdition [
	"Accept editor changes and switch back to the label"

	self isEditable
		ifFalse: [ ^ self ].

	"we should switch to label before we process acceptance, otherwise we may end up in the infinite loop"
	self switchToLabel.

	self onEditionAccepted: self text
]

{ #category : #'api - editor' }
BrEditableLabel >> cancelEdition [
	"Cancel editor changes and switch back to the label"

	self isEditable
		ifFalse: [ ^ self ].

	"we should switch to label before we process cancelation, otherwise we may end up in the infinite loop"
	self switchToLabel.

	self onEditionCancelled
]

{ #category : #initialization }
BrEditableLabel >> defaultEditorInteractions [
	^ {
		BlKeyCombination return -> [ :aShortcutEvent | aShortcutEvent currentTarget acceptEdition ].
		BlKeyCombination escape -> [ :aShortcutEvent | aShortcutEvent currentTarget cancelEdition ]
	}
]

{ #category : #initialization }
BrEditableLabel >> defaultLabelInteractions [
	^ {
		BlKeyCombination escape -> [ :aShortcutEvent | aShortcutEvent currentTarget looseFocus ].
		BlKeyCombination arrowLeft -> [ :aShortcutEvent | aShortcutEvent currentTarget focusPrevious ].
		BlKeyCombination arrowRight -> [ :aShortcutEvent | aShortcutEvent currentTarget focusNext ].
		BlKeyCombination return -> [ :aShortcutEvent | aShortcutEvent currentTarget switchToEditor ]
	}
]

{ #category : #'api - focus' }
BrEditableLabel >> focusNext [	
	self
		nextSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | anElement requestFocus ]
]

{ #category : #'api - focus' }
BrEditableLabel >> focusPrevious [
	self
		previousSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | anElement requestFocus ]
]

{ #category : #initialization }
BrEditableLabel >> initialize [
	super initialize.

	labelInteractions := self defaultLabelInteractions.
	editorInteractions := self defaultEditorInteractions.

	self fitContent.

	self
		when: BlDoubleClickEvent
		do: [ :anEvent | anEvent currentTarget switchToEditor ].
		
	self
		when: BlClickEvent
		do: [ :anEvent | anEvent currentTarget requestFocus ].

	self
		when: BlBlurEvent
		do: [ :anEvent | anEvent currentTarget acceptEdition ].

	self switchToLabel
]

{ #category : #'private - hooks' }
BrEditableLabel >> onEditionAccepted: aText [
	self viewModel model: aText copy.
	self dispatchEvent: (BrEditorAcceptWish new text: aText)
]

{ #category : #'private - hooks' }
BrEditableLabel >> onEditionCancelled [
	self text: self viewModel model copy.
	self dispatchEvent: (BrEditorCancelWish new)
]

{ #category : #'api  - mode' }
BrEditableLabel >> switchToEditor [
	"Switch to editor mode selecting the whole text"

	self selecter
		all;
		select.
		
	self viewModel model: self text copy.
	self beMode: (BrTextEditorEditableMode new withInteractions: editorInteractions)
]

{ #category : #'api  - mode' }
BrEditableLabel >> switchToLabel [
	"Switch to the label mode deselecting the text"

	self deselecter
		all;
		deselect.

	self beMode: (BrTextEditorReadonlyWithoutSelectionMode new withInteractions: labelInteractions)
]

{ #category : #'api - interactions' }
BrEditableLabel >> whenKey: aCombination editorDo: anAction [
	"Add a new editor mode interaction defined by a key combination and action"

	editorInteractions := editorInteractions copyWith: (aCombination -> anAction).
	
	self isEditable
		ifTrue: [ self addEditorShortcut: (BrTextEditorShortcut new
			combination: aCombination;
			action: anAction) ]
]

{ #category : #'api - interactions' }
BrEditableLabel >> whenKey: aCombination labelDo: anAction [
	self
		whenKey: aCombination
		labelDo: anAction
		with: nil
]

{ #category : #'api - interactions' }
BrEditableLabel >> whenKey: aCombination labelDo: anAction with: theOptions [
	"Add a new label mode interaction defined by a key combination and action"

	labelInteractions := labelInteractions copyWith: (aCombination -> anAction).
	
	self isReadOnly
		ifTrue: [ self addEditorShortcut: (BrTextEditorShortcut new
			combination: aCombination;
			action: anAction;
			options: theOptions) ]
]
