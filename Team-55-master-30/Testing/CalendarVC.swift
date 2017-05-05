//
//  CalendarVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/4/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    let today = Date()
    let currCalendar = Calendar.current
    var userID = user?["UID"]
    
    var menu = false
    let weekdayMatch = [1: "Sun", 2: "Mon", 3: "Tue", 4: "Wed", 5: "Thu", 6: "Fri", 7: "Sat"]
    var days = [Int: Date]()
    var availables = [Dictionary<String, Any>]()
    var appts = [Dictionary<String, Any>]()
    var target = [Dictionary<String, Any>]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadAvailables(option: "Available")
        loadAvailables(option: "Appointment")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weekDay = currCalendar.component(.weekday, from: today)
        let currentDay = currCalendar.component(.day, from: today)
        let currentYear = currCalendar.component(.year, from: today)
        let currentMonth = currCalendar.component(.month, from: today)
        let totalDays = (currCalendar.range(of: .day, in: .month, for: today)!).count
        
        for index in 1...7 {
            var possibleDay = currentDay + (index - weekDay)
            
            var dateComp = DateComponents()
            dateComp.year = currentYear
            dateComp.month = currentMonth
            
            if possibleDay > totalDays {
                possibleDay = possibleDay - totalDays
                if currentMonth == 12 {
                    dateComp.year = currentYear + 1
                    dateComp.month = 1
                } else {
                    dateComp.month = currentMonth + 1
                }
            }
            
            dateComp.day = possibleDay
            days[index] = currCalendar.date(from: dateComp)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "calender", for: indexPath) as! CalendarTVC
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        cell.daynum.text = formatter.string(from:days[indexPath.row + 1]!)
        cell.daily.text = weekdayMatch[indexPath.row + 1]
        formatter.dateFormat = "yyyy-MM-dd"
        
        cell.finalDate = days[indexPath.row + 1]
        var availCount = 0
        var apptCount = 0
        for avl in availables {
            if (avl["Date"] as! String == formatter.string(from:days[indexPath.row + 1] ?? Date())) {
                availCount += 1;
            }
        }
        
        for each in appts {
            if (each["Date"] as! String == formatter.string(from:days[indexPath.row + 1] ?? Date())) {
                apptCount += 1;
                
            }
        }
        
        
        
        cell.avail.text = "Available times: \(availCount)"
        cell.appt.text = "Appointments: \(apptCount)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tutorCalendarSegue" {
            if let selectVC = segue.destination as? SelectCalendarVC {
                if let calendarDate = sender as? CalendarTVC {
                    selectVC.date = calendarDate.finalDate
                }
            }
        }
        
    }
    
    func loadAvailables(option: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: days[1]!)
        let endDate = formatter.string(from: days[7]!)
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullApptsTutor.php?option=\(option)&id=\(userID!)&startDate=\(startDate)&endDate=\(endDate)")
        // declare request to proceed php file
        var request = URLRequest(url: url!)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {
                
                // no error of accessing php file
                if error == nil {
                    
                    do {
                        
                        // getting content of $returnArray variable of php file
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Dictionary<String, Any>]
                        
                        // clean up
                        
                        self.target.removeAll(keepingCapacity: false)
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.target = parseJSON
                        
                        if (option == "Available") {
                            self.availables = self.target
                        } else {
                            self.appts = self.target
                        }
                        // reload tableView to show back information
                        self.tableview.reloadData()
                        
                        
                    } catch {
                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return
                    }
                    
                } else {
                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return
                }
                
            })
            
            }.resume()
        
    }
    
    
}
