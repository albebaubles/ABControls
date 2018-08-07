//
//  ABDropDown
//  ABControls
//
//  Created by Alan Corbett on 8/2/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit


/// Provides a dropdown list as a replacement for a UIPickerView.  If the dropdown cannot display without falling off the window, it will popUP
/// - Attention: fires notification 'ABDropDownDidChangeIndex' which returns the selected index


@objc @IBDesignable public class ABDropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    
    /// Cache
    private struct Cache {
        static var frame : CGRect = CGRect.init()
        static var listItems: [String]?
        static var selected : Int = NSNotFound
        static var textColor : UIColor = UIColor.black
        static var font : UIFont = UIFont.systemFont(ofSize: 14)
        static var tableview: UITableView! = UITableView.init()
        static let dropdownHeight: CGFloat = 160
        static let defaultHeight: CGFloat = 30
        static let dropdownViewHeight: CGFloat = 130
        static var label: UILabel!
        static var button : UIButton! = UIButton.init(type: .system)
    }
    
    /// Notifications
    @objc  public static var ABDropDownDidChangeIndex : String = "ABDropDownDidChangeIndex"
    
    
    /// Sets the textcolor for text and the dropdown arrow
    @IBInspectable public var textColor : UIColor {
        didSet{
            Cache.textColor = textColor
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).textColor = textColor
                } else if view is UIButton {
                    (view as! UIButton).tintColor = textColor
                    (view as! UIButton).titleLabel?.textColor = textColor
                }
            }
            Cache.label.layer.borderColor = Cache.textColor.cgColor
            Cache.tableview.reloadData()
            setNeedsDisplay()
        }
    }
    
    
    /**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
    @IBInspectable  public var items : String = "" {
        didSet{
            Cache.listItems = items.components(separatedBy: "\n")
            updateListItems(items: Cache.listItems!)
            setNeedsDisplay()
        }
    }
    
    /// The currently selected index
    @IBInspectable  public var index : Int = NSNotFound {
        didSet{
            Cache.selected = index
            #if !TARGET_INTERFACE_BUILDER
            Cache.tableview.selectRow(at: IndexPath.init(row: Cache.selected, section: 0), animated: false, scrollPosition: .middle)
            NotificationCenter.default.post(name: NSNotification.Name(  ABDropDown.ABDropDownDidChangeIndex), object: Cache.selected)
            #endif
            
            if Cache.selected == NSNotFound {
                Cache.label.text = ""
            } else {
                Cache.label.text = " \(items.components(separatedBy: "\n")[index])"
            }
            setNeedsDisplay()
        }
    }
    
    /// Sets the font, default is system font at 14pt
    @IBInspectable  public var font : UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            Cache.font =  font
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).font = Cache.font
                } else if view is UIButton {
                    (view as! UIButton).titleLabel?.font = Cache.font
                }
            }
            setNeedsDisplay()
        }
    }
    
    
    /// the current text being displayed based on the index
    public func text() -> String {
        if Cache.selected != NSNotFound {
            return Cache.listItems![Cache.selected]
        }
        return ""
    }
    
    
    
    private func updateListItems(items: Array<String>) {
        if Cache.label != nil {
            if (items.count) > 0 {
                Cache.label.text = items[0]
            }
        }
        #if !TARGET_INTERFACE_BUILDER
        Cache.tableview.reloadData()
        #endif
    }
    
    
    @objc private func showList() {
        Cache.tableview.isHidden = !Cache.tableview.isHidden
        
        /*
         if displaying the dropdown, we need to increase the
         height of the frame to accomodate.  Need to also
         check if the dropdown would fall offscreen and if so,
         popUP instead of down.
         */
        
        if Cache.tableview.isHidden {
            frame =  CGRect.init(x: Cache.frame.origin.x,
                                 y: Cache.frame.origin.y,
                                 width: Cache.frame.width,
                                 height: Cache.defaultHeight)
        } else if Cache.frame.origin.y + Cache.dropdownHeight >  (window?.screen.bounds.size.height)!  {
            frame =    CGRect.init(x: Cache.frame.origin.x,
                                   y: Cache.frame.origin.y - Cache.dropdownViewHeight,
                                   width: Cache.frame.width,
                                   height: Cache.dropdownHeight)
        } else {
            frame =  CGRect.init(x: Cache.frame.origin.x,
                                 y: Cache.frame.origin.y,
                                 width: Cache.frame.width,
                                 height: Cache.dropdownHeight)
        }
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        setNeedsLayout()
        
    }
    
    /// required for dev time
    required override public init(frame: CGRect) {
        Cache.frame = frame
        textColor = UIColor.black
        super.init(frame:   frame)
    }
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        textColor = UIColor.black
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
        //        autoresizingMask = .init(rawValue: 0)
        
        // setup the ui controls
        Cache.frame = frame
        setupDropdownButton()
        setupLabel()
        setupTableviewDropdown()
    }
    
    private func setupLabel() {
        Cache.label = UILabel.init(frame: bounds)
        Cache.label.layer.borderColor = Cache.textColor.cgColor
        Cache.label.layer.borderWidth = 0.5
        Cache.label.text = "ABDropDown"
        addSubview(Cache.label)
    }
    
    private func setupDropdownButton() {
        if Cache.button == nil {
            Cache.button.frame = CGRect.init(x: Cache.frame.width - 30, y: 2.5, width: 25, height: 25)
            Cache.button.setImage(ABControlsStyleKit.imageOfDownArrow, for: .normal)
            Cache.button.titleLabel?.font = Cache.font
            addSubview(Cache.button)
            setNeedsDisplay()
            #if !TARGET_INTERFACE_BUILDER
            Cache.button.addTarget(self, action: #selector(showList), for: UIControlEvents.touchUpInside)
            #endif
        }
        
    }
    
    private func setupTableviewDropdown() {
        Cache.tableview.frame = CGRect.init(x: 0, y: Cache.defaultHeight, width: frame.width - 20, height: Cache.dropdownViewHeight)
        Cache.tableview.dataSource = self
        Cache.tableview.delegate = self
        Cache.tableview.isHidden = true
        Cache.tableview.indicatorStyle = .default
        Cache.tableview.isUserInteractionEnabled = true
        Cache.tableview.flashScrollIndicators()
        Cache.tableview.rowHeight = 25
        Cache.tableview.bounces = false
        Cache.tableview.alwaysBounceVertical = false
        Cache.tableview.alwaysBounceHorizontal = false
        Cache.tableview.backgroundColor = backgroundColor
        addSubview(Cache.tableview)
    }
    
    
    // MARK: - Table view data source
    //
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Cache.listItems != nil {
            return (Cache.listItems?.count)!
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.isUserInteractionEnabled = true
        cell.textLabel?.text = Cache.listItems?[indexPath.row]
        cell.textLabel?.textColor = Cache.textColor
        cell.textLabel?.font = Cache.font
        cell.backgroundColor = backgroundColor
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        showList()
    }
}
