//
//  StudentScheduleCalendarVC.swift
//  Testing
//
//  Created by Coleman Hedges on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentScheduleCalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    let today = Date()
    let currCalendar = Calendar.current
    var availables = [Dictionary<String, Any>]()
    var menu = false
    let weekdayMatch = [1: "Sun", 2: "Mon", 3: "Tue", 4: "Wed", 5: "Thu", 6: "Fri", 7: "Sat"]
    var days = [Int: Date]()
    var userID = user?["UID"]
    var tutorID: Int!
    var tutorClasses = [Dictionary<String, Any>()]
    var price: Float!
    var avlDates = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadAvailables()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeAppointment" {
            if let selectVC = segue.destination as? StudentBookVC {
                var availTime = [Dictionary<String, Any>]()
                selectVC.tutorID = self.tutorID
                selectVC.tutorClasses = self.tutorClasses
                for avl in availables {
                    if let room = sender as? StudentCalTVC {
                        selectVC.date = room.date
                        if (avl["Date"] as! String == room.date) {
                            availTime.append(avl)
                        }
                    }
                }
                selectVC.availables = availTime
                selectVC.price = self.price
                
            }
        }
        
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "studentcalendar", for: indexPath) as! StudentCalTVC
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        cell.daynum.text = formatter.string(from: days[indexPath.row + 1]!)
        cell.daily.text = weekdayMatch[indexPath.row + 1]
        formatter.dateFormat = "yyyy-MM-dd"
   
        
        var avlBool = false
        cell.date = formatter.string(from:days[indexPath.row + 1] ?? Date())
        print(availables)
        

        for avl in availables {
            avlDates.append(avl["Date"] as! String)
        }
        
        if avlDates.isEmpty {
            cell.open.text = "Not Available"
            cell.open.textColor = UIColor(colorLiteralRed: 139/255.0, green: 0/255.0, blue: 1/255.0, alpha: 1.00)
            cell.isUserInteractionEnabled = false
        }
            
        else {
            for date in avlDates {
            if (date == cell.date) {
                cell.open.text = "OPEN"
                cell.open.textColor = UIColor(colorLiteralRed: 27/255.0, green: 132/255.0, blue: 17/255.0, alpha: 1.00)
                
                cell.isUserInteractionEnabled = true
                break
            }
        }
            
        }
        return cell
    }
    
    func GoToNewShoot(){
        navigationController?.popViewController(animated: true)
    }
    
  /*  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "studentcalendar", for: indexPath!) as! StudentCalTVC
        if cell.open.text == ""{
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let alarm = UIAlertController(title: "Time is not available", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    
            alarm.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: { action in
                //run your function here
                self.GoToNewShoot()
            }))

            present(alarm, animated:true, completion:nil)
    
        }
    

        
}*/
 
    func loadAvailables() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: days[1]!)
        let endDate = formatter.string(from: days[7]!)
        print(tutorID)
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullApptsTutor.php?option=Available&id=\(tutorID!)&startDate=\(startDate)&endDate=\(endDate)")
        print("http://cgi.soic.indiana.edu/~team55/pullApptsTutor.php?option=Available&id=\(tutorID!)&startDate=\(startDate)&endDate=\(endDate)")
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
                        
                        self.availables.removeAll(keepingCapacity: false)
                        print("passed")
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.availables = parseJSON
                        print(self.availables)
                        
                        
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
