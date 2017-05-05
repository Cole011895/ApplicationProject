//
//  UpcomingVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class UpcomingVC: UITableViewController{

    
    @IBOutlet var tableviews: UITableView!
    
    var upcoming = [[Dictionary<String, Any>]]()
    var upcomingAppointments = [Dictionary<String, Any>]()
    var upcomingTutors = [Dictionary<String, Any>]()
    var upcomingClasses = [Dictionary<String, Any>]()

    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadTutors()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviews.delegate = self
        tableviews.dataSource = self
        
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if upcomingAppointments.count == 0 {
            return 1
        }
        
        return upcomingAppointments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as! UpcomingTVC
        
        if upcomingAppointments.count != 0 {
        //get a tutor and all of his/her information into the cell
        let appointment = upcomingAppointments[indexPath.row]
        let tutor = upcomingTutors[indexPath.row]
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
                        cell.tutorImage = UIImage(data: imageData!)
                    })
                }
            })
            
        }else{
            cell.photos.image = #imageLiteral(resourceName: "ava.png")
            cell.tutorImage = #imageLiteral(resourceName: "ava.png")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-MM-dddd"
        let dateForm = dateFormatter.date(from: date!)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM d"
        let correctDate = dateFormatterPrint.string(from: dateForm!)
        
        cell.dateLabel.text = correctDate
        cell.date = correctDate
            
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "kk:mm:ss"
        let timeFormStart = timeFormatter.date(from: startTime!)
        let timeFormEnd = timeFormatter.date(from: endTime!)
        let textFormatter = DateFormatter()
        textFormatter.dateFormat = "h:mma"
        let correctStart = textFormatter.string(from: timeFormStart!)
        let correctEnd = textFormatter.string(from: timeFormEnd!)
            
        cell.timeLabel.text = "\(correctStart) - \(correctEnd)"
        cell.time = "\(correctStart) - \(correctEnd)"
        
        cell.clas.text = "\(course["Category"]!) \(course["Number"]!)"
        cell.subject = "\(course["Category"]!) \(course["Number"]!)"
        
        cell.names.text = tutor["Fullname"] as? String
        cell.tutorName = tutor["Fullname"] as? String
            
        }
        else {
            cell.names.text = "No upcoming appointments!"
            cell.clas.text = ""
            cell.dateLabel.text = ""
            cell.timeLabel.text = "Try Available Tutors!"
            cell.isUserInteractionEnabled = false
        }
        return cell
        
    }
    
    
    func loadTutors() {
        var userID = user?["UID"]
        // accessing php file via url path
        
        if userID == nil {
           userID = "33"
        }
        
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullUpcoming.php?id=\(userID!)")
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
                        
                        self.upcomingAppointments = self.upcoming[0]
                        self.upcomingTutors = self.upcoming[1]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "upcomingSegue" {
            if let detailsVC = segue.destination as? StudentSelectCalendarVC {
                if let tutor = sender as? UpcomingTVC {
                    detailsVC.date = tutor.date
                    detailsVC.tutorImage = tutor.tutorImage
                    detailsVC.subject = tutor.subject
                    detailsVC.time = tutor.time
                    detailsVC.tutorName = tutor.tutorName
                    
                }
            }
        }
        
    }

    
  
    

    

}
