//
//  ABTouchDraw.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

@IBDesignable
public class ABTouchDraw: ABControl {
	private struct Cache {
		static var drawingPaths = UIBezierPath()
	}
	/// Notifications
	public static let ABSignatureCaptureDidDrawSignature: String = "ABSignatureCaptureDidDrawSignature"
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		UIColor.blue.setStroke()
		Cache.drawingPaths.stroke()
		layer.borderWidth = 1
		layer.borderColor = UIColor.black.cgColor
		layer.cornerRadius = super.cornerRadius
	}

	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		Cache.drawingPaths.move(to: (touches.first?.location(in: self))!)
		setNeedsDisplay()
	}

	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		Cache.drawingPaths.addLine(to: (touches.first?.location(in: self))!)
		setNeedsDisplay()
	}

	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		setNeedsDisplay()
		let string = self.drawing().base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
		NotificationCenter.default.post(name: Notification.Name(ABSignatureCapture.ABSignatureCaptureDidDrawSignature),
			object: string)
	}

	public func clear() {
		Cache.drawingPaths.removeAllPoints()
		setNeedsDisplay()
		layer.sublayers = nil
	}

	public func drawing() -> NSData {
		return NSKeyedArchiver.archivedData(withRootObject: Cache.drawingPaths) as NSData
	}

	public func drawingPath() -> UIBezierPath {
		return Cache.drawingPaths
	}

	public func drawing(path: UIBezierPath) {
		Cache.drawingPaths = path
		setNeedsDisplay()
	}

	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		layer.cornerRadius = super.cornerRadius
		let label = UILabel(frame: bounds.insetBy(dx: 20, dy: 20))
		label.textAlignment = .center
		label.textColor = UIColor.lightGray
		label.text = "ABTouchDraw"
		addSubview(label)
	}
}
