//
//  MasterViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls
class MasterViewController: UIViewController, ABListBoxDelegate {
    @IBOutlet weak private var listbox: ABListBox!
    var detailViewController: DetailViewController?
    var objects = [Any]()
    func didChangeListBoxIndex(_ index: Int) {
        switch index {
        case 0:
            performSegue(withIdentifier: "scanner", sender: nil)
        case 1:
            performSegue(withIdentifier: "checkbox", sender: nil)
        case 2:
            performSegue(withIdentifier: "dropdown", sender: nil)
        case 3:
            performSegue(withIdentifier: "gradient", sender: nil)
        default:
            NSLog("fall through")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = controllers.last as? DetailViewController
        }
        listbox.delegate = self
        listbox.font = .systemFont(ofSize: 17)
        listbox.rowHeight = 50
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            NSLog("show detail")
        }
    }
}
