//
//  ABRadialPotentiometer.swift
//  ABControls
//
//  Created by Alan Corbett on 8/11/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

/// currently only a placeholder -- this control will display an adjustable circlular element
@IBDesignable
public class ABPotentiometerRadial: ABControl {
    @IBInspectable public var value: Float = 50 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var color : UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var barWidth : CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }
    
	/// required for dev time
	required public init(frame: CGRect) {
		super.init(frame: frame)
		invalidateIntrinsicContentSize()
	}

	/// require for runtime
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		#if !TARGET_INTERFACE_BUILDER
			sharedInit()
		#endif
	}

	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		sharedInit()
	}

	private func sharedInit() {
		autoresizingMask = .init(rawValue: 0)
		setupRadial()
	}

	private func setupRadial() {
//		ABControlsStyleKit.drawPotentiometerRadial(frame: bounds, resizing: .aspectFit, ovalWidth: 20, percentComplete: CGFloat(percentComplete))
	}
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        ABControlsStyleKit.drawPotentiometerRadial(frame: bounds, resizing: .aspectFit, knobColor: color, ovalWidth: barWidth, percentComplete: CGFloat(value))
    }
}
