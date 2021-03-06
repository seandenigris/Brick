Class {
	#name : #BrTabGroupHeaderLook,
	#superclass : #BrLook,
	#instVars : [
		'tabs',
		'header',
		'tabbar',
		'scrollTabbar'
	],
	#category : #'Brick-Tabs - Look'
}

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> header [
	"Return an element that represents a container for tab bar and tool bar"
	<return: #BlElement>

	^ header
]

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> headerDo: aBlock [
	aBlock value: self header
]

{ #category : #initialization }
BrTabGroupHeaderLook >> initialize [
	super initialize.
	"We have the following structure:
	
	- header
		- scrollable
			- tabbar
	"
	tabs := OrderedCollection new.
	
	header := BlElement new labeled: 'Header'.
	scrollTabbar := BlScrollableElement new  labeled: 'Scrollable'.
	tabbar := BlElement new labeled: 'Tabbar'.
	
	scrollTabbar addChild: tabbar as: #tabbar.

	header addChild: scrollTabbar as: #scrolltabbar.
	
	self addChangeAddChildAs: #(header) with: [ header ].
]

{ #category : #initialization }
BrTabGroupHeaderLook >> initializeListeners [
	super initializeListeners.
	self
		when: BrTabAddedEvent
		do: [ :anEvent | self onTabAdded: anEvent tab at: anEvent position ].
	self
		when: BrTabMovedEvent
		do: [ :anEvent | self onTabMoved: anEvent tab from: anEvent oldPosition to: anEvent newPosition ].
	self
		when: BrTabRemovedEvent
		do: [ :anEvent | self onTabRemoved: anEvent tab ].
	self
		when: BrTabGroupTabsChangedEvent
		do: [ :anEvent | self onTabsChanged: anEvent tabs ].
	self
		when: BrTabSelectedEvent
		do: [ :anEvent | self onTabSelected: anEvent tab ].
	self
		when: BrTabDeselectedEvent
		do: [ :anEvent | self onTabDeselected: anEvent tab ].

]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabAdded: aBrTabModel at: anIndex [
	| anAssoc |
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'I can not receive the tab added event without being attached to a widget' ].

	anAssoc := aBrTabModel -> nil.
	self tabs add: anAssoc beforeIndex: anIndex.

	aBrTabModel whenAttachedDo: [ :aTabElement |
		self tabbar removeChildren: self tabElements.
		anAssoc value: aTabElement.
		self tabbar addChildren: self tabElements ]
]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabDeselected: aBrTabModel [ 
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'I can not receive the tab deselected event without being attached to a widget' ].

]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabMoved: aBrTabModel from: anOldIndex to: aNewIndex [
	| anAssoc |
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'I can not receive the tab moved event without being attached to a widget' ].

	anAssoc := self tabs at: anOldIndex.
	self
		assert: [ anAssoc key == aBrTabModel ]
		description: [ 'The moved tab at the old position must be identical to the local tab model at the same position' ].
	
	self tabs remove: anAssoc.
	self tabs add: anAssoc beforeIndex: aNewIndex.

	aBrTabModel whenAttachedDo: [ :aTabElement |
		self tabbar removeChildren: self tabElements.
		anAssoc value: aTabElement.
		self tabbar addChildren: self tabElements ]
]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabRemoved: aBrTabModel [
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'I can not receive the tab removed event without being attached to a widget' ].

	self tabs removeAllSuchThat: [ :eachAssoc | eachAssoc key = aBrTabModel ].
	aBrTabModel widgetDo: [ :aTabElement |
		self tabbar removeChild: aTabElement ]
]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabSelected: aTabModel [
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'I can not receive the tab selected event without being attached to a widget' ].

]

{ #category : #hooks }
BrTabGroupHeaderLook >> onTabsChanged: aCollectionOfTabs [
	self
		assert: [ self isAttachedToWidget ]
		description:
			[ 'I can not receive the tabs changed event without being attached to a widget' ].
	self tabModels do: [ :aTabElement | self onTabRemoved: aTabElement ].
	aCollectionOfTabs
		withIndexDo: [ :aBrTabModel :anIndex | self onTabAdded: aBrTabModel at: anIndex ]
]

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> scrollTabbar [
	<return: #BlElement>

	^ scrollTabbar
]

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> scrollTabbarDo: aBlock [
	aBlock value: self scrollTabbar
]

{ #category : #'private - accessing' }
BrTabGroupHeaderLook >> tabElements [
	^ self tabs 
		collect: #value 
		thenSelect: #isNotNil
]

{ #category : #'private - accessing' }
BrTabGroupHeaderLook >> tabModels [
	^ self tabs collect: #key
]

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> tabbar [
	<return: #BlElement>

	^ tabbar
]

{ #category : #'api - accessing' }
BrTabGroupHeaderLook >> tabbarDo: aBlock [
	aBlock value: self tabbar
]

{ #category : #'private - accessing' }
BrTabGroupHeaderLook >> tabs [
	^ tabs
]
