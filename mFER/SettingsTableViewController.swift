//
//  SettingsTableViewController.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // Notifications cell
    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    // Refresh interval cell
    @IBOutlet weak var refreshIntervalCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNotificationSwitch()
        setupRefreshIntervalCell()

        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshIntervalCell.detailTextLabel?.text = UserDefaults.standard.object(forKey: UserDefaultsKeys.REFRESH) as? String
        tableView.reloadData()
    }
    
    // Set up refresh interval cell
    private func setupRefreshIntervalCell() {
        refreshIntervalCell.detailTextLabel?.textColor = UIColor.lightGray
        refreshIntervalCell.detailTextLabel?.text = UserDefaults.standard.object(forKey: UserDefaultsKeys.REFRESH) as? String
    }

    // Set up notifications cell and a switch inside of the cell
    private func setupNotificationSwitch() {
        let notificationsSwitch = UISwitch()
        notificationsSwitch.isOn = UserDefaults.standard.object(forKey: UserDefaultsKeys.NOTIFICATIONS) as! Bool
        notificationsSwitch.addTarget(self, action: #selector(notificationsSwitchChanged), for: .valueChanged)
        
        notificationsCell.accessoryView = notificationsSwitch
    }
    
     func notificationsSwitchChanged(s: UISwitch) {
        s.isOn = !s.isOn

        UserDefaults.standard.set(s.isOn, forKey: UserDefaultsKeys.NOTIFICATIONS)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.reuseIdentifier == "logoutCell" {
            performLogout()
        } else if cell?.reuseIdentifier == "updateCalendar" {
            tableView.deselectRow(at: indexPath, animated: true)
            updateCalendar()
        }
    }
    
    private func performLogout() {
        Auth.logout()
        dismiss(animated: true, completion: nil)
    }
    
    private func updateCalendar() {
        Alert.showLoader()
        
        // fetch calendar and update the calendar
    }
}
