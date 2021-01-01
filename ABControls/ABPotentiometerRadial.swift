//
//  ABRadialPotentiometer.swift
//  ABControls
//
//  Created by Alan Corbett on 8/11/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

protocol ABPotentiometerRadialDelegate {
    func didChangeValue(potentiometerRadial: ABPotentiometerRadial, value: Int)
}


@IBDesignable
public class ABPotentiometerRadial: ABControl {
    private var previousPoint: CGPoint?
    private var delegate : ABPotentiometerRadialDelegate?
    
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
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousPoint = (touches.first?.location(in: self))!
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        previousPoint = (touches.first?.location(in: self))!
        setNeedsDisplay()
//        let string = self.drawing().base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
//        NotificationCenter.default.post(name: Notification.Name(ABSignatureCapture.ABSignatureCaptureDidDrawSignature),
//            object: string)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        ABControlsStyleKit.drawPotentiometerRadial(frame: bounds, resizing: .aspectFit, knobColor: color, ovalWidth: barWidth, percentComplete: CGFloat(value))
    }
}
