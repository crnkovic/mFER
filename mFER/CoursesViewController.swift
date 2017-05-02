//
//  FirstViewController.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON
import AlamofireRSSParser

class CoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var allCourses = [Course]()
    private var passedCourses = [Course]()
    private var failedCourses = [Course]()
    
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        setFooter()
        
        refresh.attributedTitle = NSAttributedString(string: "Pusti za ažuriranje predmeta", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        refresh.tintColor = UIColor.lightGray
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refresh
     
        allCourses = Repository.fetchCourses()
        sortCourses()
    }
    
    private func sortCourses() {
        for course in allCourses {
            failedCourses.append(course)
            
            for score in course.scores?.allObjects as! [Score] {
                if score.nameHr == "Kontinuirana nastava" {
                    if score.scorePassed {
                        failedCourses.removeLast()
                        passedCourses.append(course)
                    }
                }
            }
        }
    }
    
    func refreshData() {
        
        
        Alamofire.request(Endpoints.COURSES)
            .authenticate(user: Auth.username(), password: Auth.password())
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if response.result.isFailure {
                    Alert.showError(message: "Greška prilikom učitavanja predmeta. Pokušaj ponovo.")
                } else {
                    Repository.clear(entity: "Course")
                    Repository.clear(entity: "Score")
                    UserDefaults.standard.set(Double(Date.timeIntervalSinceReferenceDate), forKey: UserDefaultsKeys.UPDATED)
                    
                    for item in JSON(response.result.value!).arrayValue {
                        
                        // Save a new course to the CoreData
                        let course = Repository.createCourse(item)
                        
                        Alamofire.request(Endpoints.scores(courseID: course.id))
                            .authenticate(user: Auth.username(), password: Auth.password())
                            .validate(statusCode: 200..<300)
                            .responseJSON { response in
                                for score in JSON(response.result.value!).arrayValue {
                                    // No scores for this course
                                    if score.isEmpty {
                                        continue
                                    }
                                    
                                    Repository.createScore(course: course, data: score)
                                }
                        }
                    }
                }
                
                self.refresh.endRefreshing()
                self.tableView.reloadData()
                self.setFooter()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var data = 0
        switch segmented.selectedSegmentIndex {
        case 0: data = allCourses.count
        case 1: data = passedCourses.count
        case 2: data = failedCourses.count
        default: data = 0
        }
        
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var course: Course
        
        switch segmented.selectedSegmentIndex {
        case 0: course = allCourses[indexPath.row]
        case 1: course = passedCourses[indexPath.row]
        case 2: course = failedCourses[indexPath.row]
        default: course = allCourses[indexPath.row]
        }
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = course.nameHr
        cell.detailTextLabel?.text = "0.0"
        
        for score in course.scores?.allObjects as! [Score] {
            if score.nameHr == "Kontinuirana nastava" {
                cell.detailTextLabel?.text = String(describing: score.value)
            }
        }
        
        return cell
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Nema predmeta")
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        tableView.tableFooterView = UIView()
    }
    
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView!) {
        setFooter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeScoreSegue" {
            let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
            
            segue.destination.navigationItem.title = cell?.textLabel?.text
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    private func setFooter() {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width, height: 20))
        
        let updated = UserDefaults.standard.double(forKey: UserDefaultsKeys.UPDATED)
        let date = Date(timeIntervalSinceReferenceDate: updated)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        let dateString = dayTimePeriodFormatter.string(from: date)
        
        label.text = "Zadnji put ažurirano \(dateString)"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        
        tableView.tableFooterView = label
    }
}

