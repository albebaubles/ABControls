//
//  ABImagePicker.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class  ABImageViewer: ABControl {
    private var _imageScrollview : UIScrollView = UIScrollView.init()
    
    @objc public enum mode : Int {
        case light = 0
        case dark = 1
    }
    
    @IBInspectable public var lightMode : mode = mode.light {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// equal heights and widths
    @IBInspectable public var thumbnailSize : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var images : NSArray = NSArray.init()  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func previewSize() -> CGSize {
        return CGSize.init(width: frame.width, height: frame.height - thumbnailSize)
    }
    
    private func contentSize() -> CGSize {
        return CGSize.init(width: images.count * 30, height: 30)
    }
    
    
    private func setupImageScrollview() {
        _imageScrollview.subviews.forEach({ $0.removeFromSuperview() })
        _imageScrollview.frame = CGRect.init(x: 0, y: frame.height - thumbnailSize, width: frame.width, height: thumbnailSize)
        _imageScrollview.contentSize = contentSize()
        for case let image  in images {
            let imageButton = UIButton.init(frame: CGRect.init(x: CGFloat(images.index(of: image) * 30), y: frame.height - thumbnailSize, width: thumbnailSize, height: thumbnailSize))
            imageButton.setImage(image as? UIImage, for: .normal)
            _imageScrollview.addSubview(imageButton)
        }
    }
    
    required public init(frame: CGRect) {
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
        sharedInit()
    }
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
    }
}
