//
//  SettingsTableViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 12/26/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var sizeCell: UITableViewCell!
    @IBOutlet weak var textColorCell: UITableViewCell!
    @IBOutlet weak var backgroundColorCell: UITableViewCell!
    @IBOutlet weak var speedCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("Bala selected row at index path = \(indexPath)")
    }
    
    // MARK :- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("sizeSegue"):
            let sizeVC = segue.destination as! SettingsDetailViewController
            sizeVC.navigationItem.title = "Text Size"
            sizeVC.index = 0
        case .some("textColorSegue"):
            let sizeVC = segue.destination as! SettingsDetailViewController
            sizeVC.navigationItem.title = "Text Color"
            sizeVC.index = 1
        case .some("backgroundColorSegue"):
            let sizeVC = segue.destination as! SettingsDetailViewController
            sizeVC.navigationItem.title = "Background Color"
            sizeVC.index = 2
        case .some("speedSegue"):
            let sizeVC = segue.destination as! SettingsDetailViewController
            sizeVC.navigationItem.title = "Scroll Speed"
            sizeVC.index = 3
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
