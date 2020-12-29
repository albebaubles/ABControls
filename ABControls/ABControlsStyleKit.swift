//
//  ABControlsStyleKit.swift
//  ABControls
//
//  Created by Al Corbett on 12/29/20.
//  Copyright © 2020 AlbeBaubles LLC. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class ABControlsStyleKit : NSObject {

    //// Cache

    private struct Cache {
        static var imageOfDownArrow: UIImage?
        static var downArrowTargets: [AnyObject]?
        static var imageOfCheckedBox: UIImage?
        static var checkedBoxTargets: [AnyObject]?
        static var imageOfUncheckedBox: UIImage?
        static var uncheckedBoxTargets: [AnyObject]?
    }

    //// Drawing Methods

    @objc dynamic public class func drawDownArrow(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 30, height: 30), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 30, y: resizedFrame.height / 30)


        //// Color Declarations
        let color = UIColor(red: 0.091, green: 0.094, blue: 0.090, alpha: 1.000)

        //// Polygon Drawing
        context.saveGState()
        context.translateBy(x: 15, y: 14)
        context.rotate(by: -180 * CGFloat.pi/180)

        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 0, y: -9))
        polygonPath.addLine(to: CGPoint(x: 9.09, y: 4.5))
        polygonPath.addLine(to: CGPoint(x: -9.09, y: 4.5))
        polygonPath.close()
        color.setFill()
        polygonPath.fill()

        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawCheckedBox(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 30, height: 30), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 30, y: resizedFrame.height / 30)


        //// Color Declarations
        let color = UIColor(red: 0.091, green: 0.094, blue: 0.090, alpha: 1.000)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 3.5, y: 3.5, width: 23, height: 23), cornerRadius: 9.75)
        color.setFill()
        rectanglePath.fill()
        color.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.stroke()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 2.5, y: 2.5, width: 25, height: 25), cornerRadius: 10.75)
        color.setFill()
        rectangle2Path.fill()
        color.setStroke()
        rectangle2Path.lineWidth = 1
        rectangle2Path.stroke()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawUncheckedBox(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 30, height: 30), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 30, y: resizedFrame.height / 30)


        //// Color Declarations
        let color = UIColor(red: 0.091, green: 0.094, blue: 0.090, alpha: 1.000)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 3.5, y: 3.5, width: 23, height: 23), cornerRadius: 8.75)
        color.setStroke()
        rectanglePath.lineWidth = 2
        rectanglePath.stroke()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 1.5, y: 1.5, width: 27, height: 27), cornerRadius: 10.75)
        color.setStroke()
        rectangle2Path.lineWidth = 2
        rectangle2Path.stroke()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawPotentiometerRadial(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 500, height: 500), resizing: ResizingBehavior = .aspectFit, knobColor: UIColor = UIColor(red: 0.800, green: 0.320, blue: 0.320, alpha: 1.000), ovalWidth: CGFloat = 31, percentComplete: CGFloat = 94) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 500, height: 500), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 500, y: resizedFrame.height / 500)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 500, resizedFrame.height / 500)


        //// Color Declarations
        let color3 = UIColor(red: 0.737, green: 0.771, blue: 0.752, alpha: 1.000)

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5

        //// Variable Declarations
        let ovalBorder: CGFloat = ovalWidth + ovalWidth / 8.0
        let degree: CGFloat = -360 / (100.0 / percentComplete)

        //// Group
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)


        //// Oval Drawing
        context.saveGState()
        context.translateBy(x: 28, y: 470)
        context.rotate(by: -90 * CGFloat.pi/180)

        context.saveGState()
        context.setBlendMode(.overlay)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let ovalRect = CGRect(x: 0, y: 0, width: 442, height: 442)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: 0 * CGFloat.pi/180, endAngle: -degree * CGFloat.pi/180, clockwise: true)

        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        knobColor.setStroke()
        ovalPath.lineWidth = ovalWidth
        ovalPath.lineJoinStyle = .bevel
        context.saveGState()
        context.setLineDash(phase: 0, lengths: [2, 0])
        ovalPath.stroke()
        context.restoreGState()
        context.restoreGState()

        context.endTransparencyLayer()
        context.restoreGState()

        context.restoreGState()


        //// ringBorder Drawing
        context.saveGState()
        context.translateBy(x: 28, y: 470)
        context.rotate(by: -90 * CGFloat.pi/180)

        context.saveGState()
        context.setBlendMode(.overlay)

        let ringBorderRect = CGRect(x: 0, y: 0, width: 442, height: 442)
        let ringBorderPath = UIBezierPath()
        ringBorderPath.addArc(withCenter: CGPoint(x: ringBorderRect.midX, y: ringBorderRect.midY), radius: ringBorderRect.width / 2, startAngle: 0 * CGFloat.pi/180, endAngle: -degree * CGFloat.pi/180, clockwise: true)

        color3.setStroke()
        ringBorderPath.lineWidth = (ovalBorder + 1)
        ringBorderPath.lineCapStyle = .round
        ringBorderPath.lineJoinStyle = .bevel
        context.saveGState()
        context.setLineDash(phase: 0, lengths: [0, 0])
        ringBorderPath.stroke()
        context.restoreGState()

        context.restoreGState()

        context.restoreGState()


        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawPotentiometerLinear(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 15), resizing: ResizingBehavior = .aspectFit, knobColor: UIColor = UIColor(red: 0.800, green: 0.320, blue: 0.320, alpha: 1.000), percentComplete: CGFloat = 94) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 15), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 15)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 100, resizedFrame.height / 15)


        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: percentComplete, height: 15))
        knobColor.setFill()
        rectanglePath.fill()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 15))
        knobColor.setStroke()
        rectangle2Path.lineWidth = 1
        rectangle2Path.stroke()
        
        context.restoreGState()

    }

    //// Generated Images

    @objc dynamic public class var imageOfDownArrow: UIImage {
        if Cache.imageOfDownArrow != nil {
            return Cache.imageOfDownArrow!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 30), false, 0)
            ABControlsStyleKit.drawDownArrow()

        Cache.imageOfDownArrow = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfDownArrow!
    }

    @objc dynamic public class var imageOfCheckedBox: UIImage {
        if Cache.imageOfCheckedBox != nil {
            return Cache.imageOfCheckedBox!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 30), false, 0)
            ABControlsStyleKit.drawCheckedBox()

        Cache.imageOfCheckedBox = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfCheckedBox!
    }

    @objc dynamic public class var imageOfUncheckedBox: UIImage {
        if Cache.imageOfUncheckedBox != nil {
            return Cache.imageOfUncheckedBox!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 30), false, 0)
            ABControlsStyleKit.drawUncheckedBox()

        Cache.imageOfUncheckedBox = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfUncheckedBox!
    }

    //// Customization Infrastructure

    @objc @IBOutlet dynamic var downArrowTargets: [AnyObject]! {
        get { return Cache.downArrowTargets }
        set {
            Cache.downArrowTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: ABControlsStyleKit.imageOfDownArrow)
            }
        }
    }

    @objc @IBOutlet dynamic var checkedBoxTargets: [AnyObject]! {
        get { return Cache.checkedBoxTargets }
        set {
            Cache.checkedBoxTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: ABControlsStyleKit.imageOfCheckedBox)
            }
        }
    }

    @objc @IBOutlet dynamic var uncheckedBoxTargets: [AnyObject]! {
        get { return Cache.uncheckedBoxTargets }
        set {
            Cache.uncheckedBoxTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: ABControlsStyleKit.imageOfUncheckedBox)
            }
        }
    }




    @objc(ABControlsStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
