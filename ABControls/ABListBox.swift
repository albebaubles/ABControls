//
//  ABListBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class ABListBox: ABControl, UITableViewDelegate, UITableViewDataSource {
    
    /// Cache
    private struct Cache {
     static   var frame : CGRect = CGRect.init()
     static   var listItems: [String]?
     static   var selected : Int = NSNotFound
     static   var textColor : UIColor = UIColor.black
     static   var font : UIFont = UIFont.systemFont(ofSize: 14)
     static   var tableview: UITableView! = UITableView.init()
    }
    
    
    /// Notifications
    @objc  public static var ABListBoxDidChangeIndex : String = "ABListBoxDidChangeIndex"
    
    /// Sets the textcolor for text and the dropdown arrow
    @IBInspectable public override var textColor : UIColor {
        didSet{
            Cache.textColor = textColor
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
            NotificationCenter.default.post(name: NSNotification.Name(  ABListBox.ABListBoxDidChangeIndex), object: Cache.selected)
            #endif
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
        #if !TARGET_INTERFACE_BUILDER
        Cache.tableview.reloadData()
        #endif
    }
    
    
    
    /// required for dev time
    required  public init(frame: CGRect) {
        Cache.frame = frame
        super.init(frame:   frame)
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
        //        autoresizingMask = .init(rawValue: 0)
        
        // setup the ui controls
        Cache.frame = frame
        setupTableview()
    }
    
    
    
    
    private func setupTableview() {
        Cache.tableview.dataSource = self
        Cache.tableview.delegate = self
        Cache.tableview.isHidden = false
        Cache.tableview.indicatorStyle = .default
        Cache.tableview.isUserInteractionEnabled = true
        Cache.tableview.flashScrollIndicators()
        Cache.tableview.rowHeight = 25
        Cache.tableview.bounces = false
        Cache.tableview.alwaysBounceVertical = false
        Cache.tableview.alwaysBounceHorizontal = false
        Cache.tableview.backgroundColor = backgroundColor
        Cache.tableview.frame = bounds
        addSubview(Cache.tableview)
        Cache.tableview.reloadData()
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
    }
}
