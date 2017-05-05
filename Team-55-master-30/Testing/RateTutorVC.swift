//
//  RateTutorVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/24/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit


class RateTutorVC: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var tutorNameTxt: UILabel!
    
    var appointments = [Dictionary<String, Any>]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadAppts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //loadAppts()
        //print(appointments)
        text.delegate = self;

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
                        //print(self.appointments)
                        //print(self.appointments[0]["TutorName"])
                        //print(self.appointments[0]["AppointmentID"])
                        self.tutorNameTxt.text! = self.appointments[0]["TutorName"] as! String
                        
                        
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
    
    
    
    
    
    

    
    //closes keyboard when return is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    //submit button is clicked
    @IBAction func submitClick(_ sender: Any) {
        print(Int(cosmosView.rating))
        
        //if no rating is entered
        if cosmosView.rating == 0.0{
            DispatchQueue.main.async(execute: {
                let message = "Please rate the tutor"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })

        }
        else if text.text!.isEmpty{
            DispatchQueue.main.async(execute: {
                let message = "Please enter a review"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
        }else{
        //rating is entered

            
            // accessing php file via url path
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/rating.php")!
            
            // declare request to proceed php file
            var request = URLRequest(url: url)
            
            // declare method of passing information to php file
            request.httpMethod = "POST"
            let tutorID = self.appointments[0]["TutorID"]
            let rating = Int(cosmosView.rating)
            let appID = self.appointments[0]["AppointmentID"]
            print(tutorID)
            print(appID)
            
            //print(tutorID!, text.text!, rating)
            // body to be appended to url
            let body = "AppointmentID=\(appID!)&TutorID=\(tutorID!)&RatingText=\(text.text!)&RatingValue=\(rating)"
            print(body)
            request.httpBody = body.data(using: .utf8)
            
            // proceed request
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error == nil {
                    // go to tabbar / home page
                    DispatchQueue.main.async(execute: {
                        appDelegate.student_login()
                    })
                    /*
                    // get main queue in code process to communicate back to UI
                    DispatchQueue.main.async(execute: {
                        
                        do {
                            
                            // get json result
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            // assign json to new var parseJSON in guard/secured way
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                                print(parseJSON)
                            

                                // go to tabbar / home page
                                DispatchQueue.main.async(execute: {
                                    appDelegate.student_login()
                                })
                                
                                // error
                            
                            
                            
                        } catch {
                            
                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                print(1)
                                let message = "\(error)"
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            return
                            
                        }
                        
                        })*/
                    
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
         
            /*
        //go back to student home screen
        DispatchQueue.main.async(execute: {
            appDelegate.student_login()
        })*/
        
        }

}
}
