//
//  ABListBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
public protocol ABListboxDelegate: class {
	/// Fires when the listbox selection has changed
	///
	/// - Parameter index: index of the selected item
	func didChangeListBoxIndex(_ index: Int)
}
@IBDesignable
public class ABListbox: ABTextualControl {
	public weak var
	delegate: ABListboxDelegate?
	private var _frame: CGRect = CGRect()
	private var _listItems: [String]?
	private var _selected: Int = NSNotFound
	private var _font: UIFont = UIFont.systemFont(ofSize: 14)
	private var _tableview: UITableView! = UITableView()
	/// Notifications
	public static let ABListboxDidChangeIndex: String = "ABListBoxDidChangeIndex"
	/// Sets the textcolor for text and the dropdown arrow
	override public var textColor: UIColor {
		didSet {
			super.textColor = textColor
			_tableview.reloadData()
			layer.borderColor = textColor.cgColor
		}
	}
	override var cornerRadius: CGFloat {
		didSet {
			super.cornerRadius = cornerRadius
			_tableview.layer.cornerRadius = cornerRadius
		}
	}
    
	@IBInspectable public var rowHeight: Float = 40 {
		didSet {
			_tableview.rowHeight = CGFloat(rowHeight)
			_tableview.reloadData()
		}
	}
	/**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
	@IBInspectable public var items: String = "" {
		didSet {
			_listItems = items.components(separatedBy: "\n")
			_tableview.reloadData()
		}
	}
	/// The currently selected index
	@IBInspectable public var index: Int = NSNotFound {
		willSet {
			if index < 0 || index > (_listItems?.count)! {
				return
			}
		}
		didSet {
			_selected = index
			#if !TARGET_INTERFACE_BUILDER
				_tableview.selectRow(at: IndexPath(row: _selected, section: 0), animated: false, scrollPosition: .middle)
				NotificationCenter.default.post(name: NSNotification.Name(ABListbox.ABListboxDidChangeIndex), object: _selected)
				delegate?.didChangeListBoxIndex(index)
			#endif
		}
	}
	/// Sets the font, default is system font at 14pt
	public var font = UIFont.systemFont(ofSize: 14) {
		didSet {
			_font = font
			for view in subviews where view is UILabel || view is UIButton {
				if view is UILabel {
					(view as? UILabel)?.font = _font
				} else if view is UIButton {
					(view as? UIButton)?.titleLabel?.font = _font
				}
			}
		}
	}
	/// the current text being displayed based on the index
	public func text() -> String {
		if _selected != NSNotFound {
			return _listItems![_selected]
		}
		return ""
	}
	/// required for dev time
	required public init(frame: CGRect) {
		_frame = frame
		super.init(frame: frame)
	}
	/// require for runtime
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		#if !TARGET_INTERFACE_BUILDER
			sharedInit()
		#endif
		layer.backgroundColor = self.backgroundColor?.cgColor
	}
    
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		sharedInit()
		if self.index != NSNotFound {
			_tableview.selectRow(at: IndexPath(row: self.index, section: 0), animated: false, scrollPosition: .top)
		}
		if items.isEmpty {
			let label = UILabel(frame: bounds.insetBy(dx: 20, dy: 20))
			label.textAlignment = .center
			label.textColor = UIColor.lightGray
			label.text = "ABListBox"
			layer.masksToBounds = true
			layer.borderWidth = 0.5
			layer.borderColor = textColor.cgColor
			addSubview(label)
		}
	}
	private func sharedInit() {
		autoresizingMask = .init(rawValue: 0)
		// setup the ui controls
		_frame = frame
		setupTableview()
		_tableview.reloadData()
	}
    
	private func setupTableview() {
		_tableview.autoresizingMask = .init(rawValue: 0)
		_tableview.dataSource = self
		_tableview.delegate = self
		_tableview.isHidden = false
		_tableview.indicatorStyle = .default
		_tableview.isUserInteractionEnabled = true
		_tableview.flashScrollIndicators()
		_tableview.rowHeight = CGFloat(rowHeight)
		_tableview.bounces = false
		_tableview.alwaysBounceVertical = false
		_tableview.alwaysBounceHorizontal = false
		_tableview.backgroundColor = self.backgroundColor
		_tableview.layer.backgroundColor = self.backgroundColor?.cgColor
		_tableview.translatesAutoresizingMaskIntoConstraints = false
		addSubview(_tableview)
		_tableview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
		_tableview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		_tableview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		_tableview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
		layer.backgroundColor = self.backgroundColor?.cgColor
		layer.borderColor = self.textColor.cgColor
		layer.borderWidth = 0.5
	}
}

extension ABListbox: UITableViewDelegate {
	// MARK: - Table view delegate
	//
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		index = indexPath.row
	}
    
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.layer.backgroundColor = self.backgroundColor?.cgColor
	}
}

extension ABListbox: UITableViewDataSource {
    // MARK: - Table view data source
    //
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _tableview.isHidden = true
        if _listItems != nil {
            _tableview.isHidden = false
            return (_listItems?.count)!
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.isUserInteractionEnabled = true
        cell.textLabel?.text = _listItems?[indexPath.row]
        cell.textLabel?.font = _font
        cell.textLabel?.textColor = self.textColor
        cell.layer.backgroundColor = self.backgroundColor?.cgColor
        return cell
    }
}
