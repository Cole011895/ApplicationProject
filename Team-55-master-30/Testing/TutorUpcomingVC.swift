//
//  TutorUpcomingVC.swift
//  Testing
//
//  Created by Garrett Lee on 2/19/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorUpcomingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableviews: UITableView!
    
    var upcoming = [[Dictionary<String, Any>]]()
    var upcomingAppointments = [Dictionary<String, Any>]()
    var upcomingStudents = [Dictionary<String, Any>]()
    var upcomingClasses = [Dictionary<String, Any>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableviews.delegate = self
        tableviews.dataSource = self
        
        loadStudents()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if upcomingAppointments.count == 0 {
            print("Here")
            return 1
        }
        return upcomingAppointments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviews.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as! TutorUpcoming
        
        if upcomingAppointments.count != 0 {
            
        let appointment = upcomingAppointments[indexPath.row]
        let tutor = upcomingStudents[indexPath.row]
        let course = upcomingClasses[indexPath.row]
        
        let date = appointment["Date"] as? String
        let startTime = appointment["Start"] as? String
        let endTime = appointment["End"] as? String
        
        let ava = tutor["Ava"] as! String
        
        if ava != "" {
            
            // url path to image
            let imageURL = URL(string: ava)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        cell.photos.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }else{
            cell.photos.image = #imageLiteral(resourceName: "ava.png")
        }
        
        cell.date.text = date
        cell.time.text = "\(startTime!) - \(endTime!)"
        
        cell.clas.text = "\(course["Category"]!) \(course["Number"]!)"
        cell.names.text = tutor["Fullname"] as? String
        
        return cell
        }
        else {
            cell.names.text = "No upcoming appointments!"
            cell.clas.text = ""
            cell.date.text = ""
            cell.time.text = "Try adding more classes!"
            return cell
        }
    }
    
    func loadStudents() {
        var userID = user?["UID"]
        // accessing php file via url path
        
        if userID == nil {
            userID = "33"
        }
        
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullUpcomingStudents.php?id=\(userID!)")
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
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[Dictionary<String, Any>]]
                        
                        // clean up
                        self.upcoming.removeAll(keepingCapacity: false)
                        self.tableviews.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.upcoming = parseJSON
                        print(self.upcoming)
                        
                        self.upcomingAppointments = self.upcoming[0]
                        self.upcomingStudents = self.upcoming[1]
                        self.upcomingClasses = self.upcoming[2]
                        
                        
                        
                        // reload tableView to show back information
                        self.tableviews.reloadData()
                        
                        
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
