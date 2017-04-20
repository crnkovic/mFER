//
//  SettingsTableViewController.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit
import Alamofire

class SettingsTableViewController: UITableViewController {
    
    // Notifications cell
    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    // Refresh interval cell
    @IBOutlet weak var refreshIntervalCell: UITableViewCell!
    
    // Username cell
    @IBOutlet weak var usernameCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        usernameCell.textLabel?.text = UserDefaults.standard.object(forKey: UserDefaultsKeys.USERNAME) as? String
        
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
            tableView.deselectRow(at: indexPath, animated: true)
            performLogout()
        } else if cell?.reuseIdentifier == "updateCalendar" {
            tableView.deselectRow(at: indexPath, animated: true)
            updateCalendar()
        }
    }
    
    private func performLogout() {
        Auth.logout()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
            
            appDelegate.window?.swapRootViewControllerWithAnimation(newViewController: vc, animationType: .Present)
        }
    }
    
    private func updateCalendar() {
        Alert.showLoader()
        
        Alamofire.request(Endpoints.CALENDAR, method: .get)
            .authenticate(user: Auth.username(), password: Auth.password())
            .responseString { response in
                print (response)
                Alert.showSuccess(message: "Kalendar ažuriran!")
        }
        
        // fetch calendar and update the calendar
    }
}
