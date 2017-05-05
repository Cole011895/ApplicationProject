//
//  SelectCalendarVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class SelectCalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    var availables = [Dictionary<String, Any>]()
    var upcomingAppointments = [Dictionary<String, Any>]()
    var date: Date!
    var target = [Dictionary<String, Any>]()
    var userID = user?["UID"]
    var apptCount = 0
    
    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        
        loadAppointments(option: "Appointment")
        loadAppointments(option: "Available")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            if let selectVC = segue.destination as? addscheduleVC {
                selectVC.date = self.date
            }
        }
        else if segue.identifier == "selectCalendarSegue"{
            if let selectVC = segue.destination as? EditScheduleViewController {
                selectVC.date = self.date
                if let room = sender as? SelectedCalendarTVC {
                    selectVC.initialStart = room.start.text
                    selectVC.initialEnd = room.end.text
                    selectVC.availID = room.availID
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingAppointments.count + availables.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath) as!SelectedCalendarTVC
        
        //get a tutor and all of his/her information into the cell
        
        if (self.apptCount > 0) {
            let appointment = upcomingAppointments[indexPath.row]
            cell.start.text = appointment["Start"] as? String!
            cell.end.text = appointment["End"] as? String!
            cell.availID = appointment["AppointmentID"] as! Int
            cell.backgroundColor = UIColor(colorLiteralRed: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.40)
            cell.start.textColor = UIColor(colorLiteralRed: 139/255.0, green: 0/255.0, blue: 1/255.0, alpha: 1.00)
            cell.end.textColor = UIColor(colorLiteralRed: 139/255.0, green: 0/255.0, blue: 1/255.0, alpha: 1.00)
            cell.isAppointment = true
            cell.isUserInteractionEnabled = false
            self.apptCount -= 1
            
        } else {
            let avl = availables[indexPath.row - upcomingAppointments.count]
            cell.start.text = avl["Start"] as? String!
            cell.end.text = avl["End"] as? String!
            cell.availID = avl["AvailableID"] as! Int
        }
        
        return cell
        
    }
   
    
  /*  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.upcomingAppointments.remove(at: indexPath.row)
            tableview.reloadData()
        }
        
    }*/
    
    
    
    func loadAppointments(option: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullApptsTutor.php?option=\(option)&id=\(userID!)&startDate=\(dateString)")
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
                            self.upcomingAppointments = self.target
                        }
                        
                        // reload tableView to show back information
                        self.tableview.reloadData()
                        
                        self.apptCount = self.upcomingAppointments.count
                        print(self.availables)
                        print(self.upcomingAppointments)
                        
                        
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
