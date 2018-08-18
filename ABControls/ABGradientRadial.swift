//
//  ABGradientRadial.swift
//  ABControls
//
//  Created by Alan Corbett on 8/14/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class ABGradientRadial: ABControl {
    
    @objc @IBInspectable public var colors : CFArray = [ UIColor.green.cgColor, UIColor.blue.cgColor] as CFArray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc @IBInspectable public var radius : CGFloat = 340 / 2  {
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    
    /// required for dev time
    required  public init(frame: CGRect) {
        super.init(frame:  frame)
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
        
        // Setup view
        let locations = [ 0.0, 1.0 ] as [CGFloat]
        let center = CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        
        // Prepare a context and create a color space
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create gradient object from our color space, color components and locations
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        // Draw a gradient
        context!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
        
        context?.restoreGState()
    }
}
