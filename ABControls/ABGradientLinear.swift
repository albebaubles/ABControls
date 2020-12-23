//
//  ABGradientLinear.swift
//  ABControls
//
//  Created by Alan Corbett on 8/14/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

@IBDesignable
public class ABGradientLinear: ABControl {

	public var colors: CFArray = [UIColor.green.cgColor, UIColor.purple.cgColor] as CFArray {
		didSet { setNeedsDisplay() }
	}

    @IBInspectable public var startPoint = CGPoint(x: 0, y: 1)
    @IBInspectable public var endPoint = CGPoint(x: 1, y: 0)

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
	}

	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		layer.cornerRadius = super.cornerRadius
		// Setup view
		let locations = [0.0, 1.0] as [CGFloat]
		// Prepare a context and create a color space
		let context = UIGraphicsGetCurrentContext()
		context!.saveGState()
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		// Create gradient object from our color space, color components and locations
		let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
		context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
		context?.restoreGState()
	}
}
