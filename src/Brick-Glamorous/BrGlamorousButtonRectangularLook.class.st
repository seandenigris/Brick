"
I define the rectangular exterior of the button
"
Class {
	#name : #BrGlamorousButtonRectangularLook,
	#superclass : #BrInteractiveCommonLook,
	#category : #'Brick-Glamorous-Buttons - Support'
}

{ #category : #initialization }
BrGlamorousButtonRectangularLook >> initialize [
	super initialize.

	self
		addChangeProperty: #(widgetContent geometry)
		with: (BlRoundedRectangleGeometry cornerRadius: 4).
		
	self add: BrGlamorousButtonLayoutLook new.
	
	self add: (BrSizeAdjustmentLook new
		mini: [ :aWidget |
			aWidget
				vExact: 12;
				padding: (BlInsets left: 4 right: 4) ];
		tiny: [ :aWidget |
			aWidget
				vExact: 16;
				padding: (BlInsets left: 6 right: 6) ];
		small: [ :aWidget | 
			aWidget
				vExact: 20;
				padding: (BlInsets left: 8 right: 8) ];
		default: [ :aWidget | 
			aWidget
				vExact: 24;
				padding: (BlInsets left: 10 right: 10) ];
		large: [ :aWidget | aWidget
			vExact: 30;
			padding: (BlInsets left: 10 right: 10) ];
		huge: [ :aWidget |
			aWidget
				vExact: 48;
				padding: (BlInsets left: 16 right: 16) ])
]
