//
//  ABTextualControl.swift
//  ABControls
//
//  Created by Alan Corbett on 8/8/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

public class ABTextualControl: ABControl {
	private struct Cache {
		static var textColor = UIColor.black
	}
	/// Sets the textcolor for text and the dropdown arrow
	@IBInspectable public var textColor: UIColor {
		didSet {
			Cache.textColor = textColor
			for view in subviews where view is UILabel {
				(view as? UILabel)?.textColor = textColor
			}
		}
	}

	/// required for dev time
	required public init(frame: CGRect) {
		textColor = Cache.textColor
		super.init(frame: frame)
	}

	/// require for runtime
	required public init?(coder aDecoder: NSCoder) {
		textColor = Cache.textColor
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
		textColor = Cache.textColor
	}
}
