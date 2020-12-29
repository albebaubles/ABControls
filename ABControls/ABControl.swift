//
//  ABControl.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

@IBDesignable
public class ABControl: UIView {
	private struct Cache {
		static var textColor = UIColor.black
	}

	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}

	/// required for dev time
	required override public init(frame: CGRect) {
//		cornerRadius = 0
		super.init(frame: frame)
	}

	/// require for runtime
	required public init?(coder aDecoder: NSCoder) {
//		cornerRadius = 0
		super.init(coder: aDecoder)
		#if !TARGET_INTERFACE_BUILDER
			sharedInit()
		#endif
	}

	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		sharedInit()
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 0.5
	}

	private func sharedInit() {
		backgroundColor = super.backgroundColor
	}
}
