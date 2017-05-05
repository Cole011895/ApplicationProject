//
//  StudentCalendarVC.swift
//  Testing
//
//  Created by Coleman Hedges on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentCalendarVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var date: Date!
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //This allows for only registered users to view the page. Requires them to log in first
    override func viewWillAppear(_ animated: Bool) {
        if user == nil {
            
            let slogin = self.storyboard?.instantiateViewController(withIdentifier: "StudentLoginVC") as! StudentLoginVC
            self.present(slogin, animated: true, completion: nil)
        }
    }
    
    let sect = [ "Feb 28", "March 1", "March2"]
    
    var menu = false
    let nam = ["Matt H.", "Dan B.", "Logan J."]
    let dat = ["12:34PM", "8:00AM", "1:30PM"]
    let cla = ["M118","I201","D434"]
    let loca = ["Wells Library","IMU","Hodge Hall"]
    
    let nam2 = ["Megan M.", "Noah H.", "Caitlyn S."]
    let dat2 = ["12:34PM", "8:00AM", "1:30PM"]
    let cla2 = ["M223","J234","K534"]
    let loca2 = ["Wells Library","IMU","Hodge Hall"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:     Int) -> String? {
        return sect[section]
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Calendar", for: indexPath) as! StudentCalendarTVC
        cell.name.text = nam[indexPath.row]
        cell.subject.text = cla[indexPath.row]
        cell.timing.text = dat[indexPath.row]
        cell.locations.text = loca[indexPath.row]
        cell.name.text = nam2[indexPath.row]
        cell.subject.text = cla2[indexPath.row]
        cell.timing.text = dat2[indexPath.row]
        cell.locations.text = loca2[indexPath.row]
        return cell
    }
    
    
    
    
    
    
}
