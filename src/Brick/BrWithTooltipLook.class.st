Class {
	#name : #BrWithTooltipLook,
	#superclass : #BrWithAnchoredLook,
	#instVars : [
		'clickEventHandler',
		'overEventHandler',
		'outEventHandler',
		'hideLaterTask',
		'showLaterTask',
		'showDelay',
		'hideDelay'
	],
	#category : #'Brick-Tooltip - Look'
}

{ #category : #'as yet unclassified' }
BrWithTooltipLook class >> anchoredLookClass [
	^ BrTooltipLook
]

{ #category : #accessing }
BrWithTooltipLook >> cancelHideLater [
	hideLaterTask ifNotNil: [ :aTask | aTask stop ].
	hideLaterTask := nil
]

{ #category : #accessing }
BrWithTooltipLook >> cancelShowLater [
	showLaterTask ifNotNil: [ :aTask | aTask stop ].
	showLaterTask := nil
]

{ #category : #accessing }
BrWithTooltipLook >> hide [
	super hide.
	self willShowLater
		ifTrue: [ self cancelShowLater ].
	self willHideLater
		ifTrue: [ self cancelHideLater ]
]

{ #category : #accessing }
BrWithTooltipLook >> hideDelay [
	^ hideDelay
]

{ #category : #accessing }
BrWithTooltipLook >> hideDelay: anObject [
	hideDelay := anObject
]

{ #category : #accessing }
BrWithTooltipLook >> hideLater [
	self assert: [ self canHide ].
	self cancelHideLater.
	hideLaterTask := BlDelayedTaskAction new
		delay: self hideDelay;
		action: [ self canHide
				ifTrue: [ self hide ].
			hideLaterTask := nil ];
		yourself.
	container enqueueTask: hideLaterTask
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> hideWishClass [
	^ BrTooltipHideWish
]

{ #category : #initialization }
BrWithTooltipLook >> initialize [
	super initialize.
	clickEventHandler := BlEventHandler
		on: BlClickEvent
		do: [ self willHideLater
				ifTrue: [ self cancelHideLater ].
			self canHide
				ifTrue: [ self hide ] ].
	overEventHandler := BlEventHandler
		on: BlMouseEnterEvent
		do: [ :e | 
			self willHideLater
				ifTrue: [ self cancelHideLater ].
			self canShow
				ifTrue: [ self showLater ] ].
	outEventHandler := BlEventHandler
		on: BlMouseLeaveEvent
		do: [ :e | 
			self willShowLater
				ifTrue: [ self cancelShowLater ].
			self canHide
				ifTrue: [ self hideLater ] ].
	self
		addChange:
			(BrLookChange new
				up: [ :e | 
					widget
						addEventHandler: clickEventHandler;
						addEventHandler: overEventHandler;
						addEventHandler: outEventHandler ];
				down: [ :e | 
					widget
						removeEventHandler: clickEventHandler;
						removeEventHandler: overEventHandler;
						removeEventHandler: outEventHandler ];
				yourself);
		addChange:
			(BrLookChange new
				up: [ :e |  ];
				down: [ :e | 
					self willShowLater
						ifTrue: [ self cancelShowLater ].
					self willHideLater
						ifTrue: [ self cancelHideLater ] ];
				yourself).
	self showDelay: 1000 milliSeconds.
	self hideDelay: 300 milliSeconds
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> relocateWish [
	^ BrTooltipRelocateWish new
]

{ #category : #'host space - displaying' }
BrWithTooltipLook >> show [
	super show.
	self willShowLater
		ifTrue: [ self cancelShowLater ].
	self willHideLater
		ifTrue: [ self cancelHideLater ].
	container
		addEventHandlerOn: BlMouseEnterEvent do: [ self cancelHideLater ];
		addEventHandlerOn: BlMouseLeaveEvent do: [ self hideLater ]
]

{ #category : #accessing }
BrWithTooltipLook >> showDelay [
	^ showDelay
]

{ #category : #accessing }
BrWithTooltipLook >> showDelay: anObject [
	showDelay := anObject
]

{ #category : #accessing }
BrWithTooltipLook >> showLater [
	self assert: [ self canShow ].
	self cancelShowLater.
	showLaterTask := BlDelayedTaskAction new
		delay: self showDelay;
		action: [ self canShow
				ifTrue: [ self show ].
			showLaterTask := nil ];
		yourself.
	widget enqueueTask: showLaterTask
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> showWishClass [
	^ BrTooltipShowWish
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> stencilChangedClass [
	^ BrTooltipStencilChanged
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> stencilRequest [
	^ BrTooltipStencilRequest new
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> visibleChangedClass [
	^ BrTooltipVisibleChanged
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> visibleRequest [
	^ BrTooltipVisibleRequest new
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> willHideLater [
	^ hideLaterTask isNotNil
]

{ #category : #'as yet unclassified' }
BrWithTooltipLook >> willShowLater [
	^ showLaterTask isNotNil
]
