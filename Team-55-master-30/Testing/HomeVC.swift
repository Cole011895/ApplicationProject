//
//  ViewController.swift
//  Testing
//
//  Created by Coleman Hedges on 1/7/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var upcoming: UIView!
    @IBOutlet weak var available: UIView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var login: UIBarButtonItem!
    
    var appointments = [Dictionary<String, Any>]()
    
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil{
            logout.title = "Logout"
            login.title = ""
            self.loadAppts()
        }else{
            logout.title = ""
            login.title = "Login"
            
        }
        //check the time so a student can rate a tutor after a session
        let date = Date()
        let cal = Calendar.current
        
        let hour =  cal.component(.hour, from: date)
        let minutes =  cal.component(.minute, from: date)
        let seconds =  cal.component(.second, from: date)
        
        


    }
    
    func loadAppts(){
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullApptsUser.php")!
        
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
                        
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        
                        self.appointments = parseJSON as [Dictionary<String, Any>]
                        print(1)
                        print(self.appointments)
                        print(2)
                        let date = Date()
                        let cal = Calendar.current
                        let formatter = DateFormatter()
                        
                        
                        formatter.dateFormat = "yyyy-MM-dd"
                        let newdate = formatter.string(from: date)
                        
                        let hour =  cal.component(.hour, from: date)
                        let minutes =  cal.component(.minute, from: date)
                        
                        
                        
                        
                        for app in self.appointments{
                            //check the time and compare
                            //let endtime = self.appointments[0]["End"] as! String
                            //let endDate = self.appointments[0]["Date"] as! String
                            
                            let endtime = app["End"] as! String
                            let endDate = app["Date"] as! String
                            
                            
                            
                            let indexHour = endtime.index(endtime.startIndex, offsetBy: 2)
                            
                            let minStart = endtime.index(endtime.startIndex, offsetBy: 3)
                            let minEnd = endtime.index(endtime.endIndex, offsetBy: -3)
                            let range = minStart..<minEnd
                            let indexMin = endtime.substring(with: range)
                            
                            
                            
                            let endTimeHour = Int(endtime.substring(to: indexHour))
                            let endTimeMin = Int(indexMin)
                            
                            
                            
                            
                            //checking day and time of current day and appt to check whether rating page should pop up
                            if newdate == endDate{
                                if hour == endTimeHour!{
                                    if minutes - endTimeMin! > 0{
                                        print("rate!")
                                        appDelegate.rate()
                                    }

                                }else if hour - endTimeHour! > 0{
                                    print("rate!")
                                    appDelegate.rate()
                                }
                                print("same day")
                            }else{
                                print("not same day")
                                appDelegate.rate()
                            }
                            print(newdate)
                            print(endDate)
                            
                        }//end for loop

                        
                        
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
    
    

    
    @IBAction func show(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.upcoming.alpha = 1
                self.available.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.upcoming.alpha = 0
                self.available.alpha = 1
            })
        }
    }
    
    
    
    /*
    func loadAppts(){
     
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullAppts.php")!
        
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
                        
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.appointments = parseJSON as [Dictionary<String, Any>]
                        print(self.appointments)
                        
                        
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
        
        
    }*/
    

    @IBAction func login_click(_ sender: Any) {
        if user == nil{
        // go to student login page
        let slogin = self.storyboard?.instantiateViewController(withIdentifier: "StudentLoginVC") as! StudentLoginVC
        self.present(slogin, animated: true, completion: nil)
        }
    }
    

    @IBAction func logout_click(_ sender: Any) {
        if user != nil{
        // remove saved information
        UserDefaults.standard.removeObject(forKey: "parseJSON")
        UserDefaults.standard.synchronize()
        user = nil
        // go to landing page
        let landingvc = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
        self.present(landingvc, animated: true, completion: nil)
        print(user)
        }
    }

    

 
    

}


