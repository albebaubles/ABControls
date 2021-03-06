//
//  ABImagePicker.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

@IBDesignable
public class ABImageViewer: ABControl {
	private var _imageScrollview: UIScrollView = UIScrollView()
	private var _preview: UIImageView = UIImageView()
	private var _selected: UIImage?
    
	public enum LightMode: Int {
		case clear = 0
		case light = 1
		case dark = 2
	}
    
	public var lightMode = LightMode.clear {
		didSet {
			_preview.backgroundColor = background()
			_imageScrollview.backgroundColor = background().withAlphaComponent(0.8)
			setNeedsDisplay()
		}
	}

	/// equal heights and widths
	@IBInspectable public var thumbnailSize: CGFloat = 0 {
		didSet {
			setupImageScrollview()
			setupPreview()
		}
	}

	/// An NSArray of UIImages to be displayed
	public var images = NSArray() {
		didSet {
			setupImageScrollview()
			setNeedsDisplay()
			_preview.image = images[0] as? UIImage
		}
	}

	/// Returns the selected index
	///
	/// - Returns: UIImage
	public func selected() -> UIImage {
		return _selected!
	}

	private func background() -> UIColor {
		return lightMode == LightMode.clear ? .clear : lightMode == LightMode.light ? .white : .black
	}

	private func foreground() -> UIColor {
		return lightMode != LightMode.clear ? .clear : lightMode != LightMode.light ? .white : .black
	}

	private func previewSize() -> CGSize {
		return CGSize(width: bounds.width, height: bounds.height - thumbnailSize)
	}

	private func contentSize() -> CGSize {
		return CGSize(width: images.count * Int(thumbnailSize), height: Int(thumbnailSize))
	}

	private func setupImageScrollview() {
		_imageScrollview.removeFromSuperview()
		_imageScrollview.subviews.forEach({ $0.removeFromSuperview() })
		_imageScrollview.frame = CGRect(x: 0, y: bounds.height - thumbnailSize,
                                        width: bounds.width, height: thumbnailSize)
		_imageScrollview.contentSize = contentSize()

		for case let image in images {
			let imageButton = UIButton(type: .custom)
			imageButton.frame = CGRect(x: CGFloat(_imageScrollview.subviews.count * Int(thumbnailSize)), y: 0, width: thumbnailSize, height: thumbnailSize)
			imageButton.setImage(image as? UIImage, for: .normal)
			imageButton.backgroundColor = .clear
			imageButton.layer.borderColor = foreground().cgColor
			imageButton.layer.borderWidth = 1.0
			imageButton.tag = _imageScrollview.subviews.count
			imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
			_imageScrollview.addSubview(imageButton)
		}
		addSubview(_imageScrollview)
	}

	@objc
	private func selectImage(button: UIButton) {
		_selected = button.image(for: .normal)
		_preview.image = _selected
	}

	private func setupPreview() {
		_preview.removeFromSuperview()
		_preview.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: previewSize())
		_preview.backgroundColor = background()
		_preview.contentMode = .scaleAspectFit
		addSubview(_preview)
	}

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
		let label = UILabel(frame: bounds.insetBy(dx: 20, dy: 20))
		label.textAlignment = .center
		label.textColor = UIColor.lightGray
		label.text = "ABImageViewer"
		addSubview(label)
	}

	private func sharedInit() {
		autoresizingMask = .init(rawValue: 0)
		setupImageScrollview()
		setupPreview()
		setupImageScrollview()
	}
}
