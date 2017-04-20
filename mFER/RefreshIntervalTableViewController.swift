//
//  RefreshIntervalTableViewController.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit

class RefreshIntervalTableViewController: UITableViewController {
    @IBOutlet weak var min15Cell: UITableViewCell!
    @IBOutlet weak var min30Cell: UITableViewCell!
    @IBOutlet weak var hour1Cell: UITableViewCell!
    @IBOutlet weak var hour6Cell: UITableViewCell!
    @IBOutlet weak var hour24Cell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interval = UserDefaults.standard.object(forKey: UserDefaultsKeys.REFRESH) as! String
        
        for cell in [min15Cell, min30Cell, hour1Cell, hour6Cell, hour24Cell] {
            if cell?.textLabel?.text == interval {
                cell?.accessoryType = .checkmark
            }
        }
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        for cell in tableView.visibleCells {
            cell.accessoryType = selectedCell?.textLabel?.text == cell.textLabel?.text ? .checkmark : .none
        }
        
        UserDefaults.standard.set(selectedCell?.textLabel?.text!, forKey: UserDefaultsKeys.REFRESH)
    }

}
