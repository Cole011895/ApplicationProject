//
//  TutorClassSelectViewController.swift
//  Testing
//
//  Created by Coleman Hedges on 4/7/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorClassSelectViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var boxon = UIImage(named:"check")
    var boxoff = UIImage(named: "uncheck")
    var boxclicked:Bool!
    var teachesArray = [Int]()
    var coursesArray = [Int]()
    var classes = [Dictionary<String, Any>]()
    var userID = user?["UID"] as! String
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullClasses()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cells")! as! TutorClassSelectVTC
        
        cell.checkbox.addTarget(self, action:#selector(TutorClassSelectViewController.tickClicked(_:)), for: .touchUpInside)
        
        cell.checkbox.tag=indexPath.row
        
        if teachesArray[indexPath.row] == 1 {
            cell.checkbox.setBackgroundImage(UIImage(named:"check.png"), for: UIControlState())
        }
            
        else
        {
            cell.checkbox.setBackgroundImage(UIImage(named:"uncheck.png"), for: UIControlState())
        }
        
        let classCategory = classes[indexPath.row]["Category"] as! String!
        let classNumber = classes[indexPath.row]["Number"] as! Int!
        
        cell.textLabel?.text = "\(classCategory!) \(classNumber!)"
        
        return cell
    }
    
    
    func tickClicked(_ sender: UIButton!)
    {
        let value = sender.tag;
        
        if teachesArray[value] == 1
        {
            teachesArray[value] = 0
        }
        else
        {
            teachesArray[value] = 1
        }
        print(teachesArray)
        tableview.reloadData()
        
    }
    
    func pullClasses() {
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullTutorClasses.php?id=\(userID)")!
        
        // declare request to proceed php file
        var request = URLRequest(url: url)
        
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
                        self.classes.removeAll(keepingCapacity: false)
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.classes = parseJSON as [Dictionary<String, Any>]
                        
                        for course in self.classes {
                            self.teachesArray.append(course["Teaching"] as! Int)
                            self.coursesArray.append(course["ClassID"] as! Int)
                        }
                        
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
    
    func pushClasses() {
        
        var teachesString = ""
        for number in self.teachesArray{
            teachesString += "\(number)"
        }
        
        var classesString = ""
        for number in self.coursesArray{
            if classesString == "" {
                classesString += "\(number)"
            }else {
                classesString += "%20\(number)"
            }
        }
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/updateCourses.php?teachingArray=\(teachesString)&tutorID=\(userID)&courseIDs=\(classesString)")!
        print(url.absoluteString)
        
        // declare request to proceed php file
        var request = URLRequest(url: url)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
                
                // get main queue in code process to communicate back to UI
                DispatchQueue.main.async(execute: {
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                    } catch {
                        
                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return
                        
                    }
                    
                })
                
                // if unable to proceed request
            } else {
                
                // get main queue to communicate back to user
                DispatchQueue.main.async(execute: {
                    let message = error!.localizedDescription
                    appDelegate.infoView(message: message, color: colorSmoothRed)
                })
                return
                
            }
            
            // launch prepared session
            }.resume()
        
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        pushClasses()
        let alert = UIAlertController(title: "Classes Updated", message: "The classes that you are teaching have been updated.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
