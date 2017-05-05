//
//  StudentPastAppointmentsVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentPastAppointmentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadPastAppts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var tableview: UITableView!
    var pastAppointments = [Dictionary<String, Any>]()
    
    var menu = false
    let nam = ["Matt H.", "Dan B.", "Logan J."]
    let dat = ["01/18/95", "04/30/17", "03/3/10"]
    let cla = ["M118","I201","D434"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        return pastAppointments.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "PastCell", for: indexPath) as! StudentPastAppointmentsTableViewCell
        
        var app = Dictionary<String,Any>()
        
        app = pastAppointments[indexPath.row]
        
        let name = app["TutorName"] as? String
        let category = app["Category"] as? String
        let number = app["Number"] as! Int
        let date = app["Date"] as! String
        
        //****Change to different date style********
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yy"
        let date2 = formatter.date(from: date)
        //print(type(of:date2 as! String))
        print(formatter.date(from: "2017-04-05"))
        
        //cell.name.text = nam[indexPath.row]
        //cell.classy.text = cla[indexPath.row]
        //cell.date.text = dat[indexPath.row]
        cell.name.text = name
        cell.classy.text = category
        cell.date.text = date
        cell.number.text = String(number)
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Report") { action, index in
            let report = self.storyboard?.instantiateViewController(withIdentifier: "report") as! ReportVC
            self.navigationController?.pushViewController(report, animated: true)
        }
        edit.backgroundColor = .red
        
        return [edit]
        
    }*/
    
    
    func loadPastAppts(){
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullPastApptsStudent.php")!
        
        // declare request to proceed php file
        var request = URLRequest(url: url)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        let userID = user!["UID"] as? String
        
        // body to be appended to url
        let body = "id=\(userID!)"
        
        request.httpBody = body.data(using: .utf8)
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {
                
                // no error of accessing php file
                if error == nil {
                    
                    do {
                        
                        // getting content of $returnArray variable of php file
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Dictionary<String, Any>]
                        
                        self.pastAppointments.removeAll(keepingCapacity: false)
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        
                        self.pastAppointments = parseJSON
                        //print(self.pastAppointments)
                        //print(self.pastAppointments[0]["TutorName"])
                        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportSegue" {
            if let report = segue.destination as? ReportVC {
                if let app1 = sender as? StudentPastAppointmentsTableViewCell {
                    report.tutorName = app1.name.text!
                    report.date = app1.date.text!
                }
            }
        }
        
    }

    
    
    
    
}
