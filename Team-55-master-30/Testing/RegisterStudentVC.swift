//
//  registerViewController.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class RegisterStudentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var firstnameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.emailTxt.delegate = self;
        self.firstnameTxt.delegate = self;

        self.emailTxt.isUserInteractionEnabled = false
        self.firstnameTxt.isUserInteractionEnabled = false
        
        
        
        emailTxt.text! = (user!["Email"]! as? String)!
        firstnameTxt.text! = (user!["Fullname"]! as? String)!
        
        
    }
    
    //This allows for whenever you hit the Return key on the key board, the keyboard will disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @IBAction func register_click(_ sender: Any) {
        
            // remove keyboard
            self.view.endEditing(true)
            
            // url to php file
            //let url = URL(string: "http://cgi.soic.indiana.edu/~team55/registerCT.php")!
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/registerUserTutor2.php")!
            
            // request to this file
            var request = URLRequest(url: url)
            
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            
            // body to be appended to url
            let body = "Email=\(emailTxt.text!)"
            
            request.httpBody = body.data(using: .utf8)
            
            // proceed request
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error == nil {
                    
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
                            
                            
                            // get id from parseJSON dictionary
                            //let id = parseJSON["UID"]
                            
                            
                            /*
                            // successfully registered
                            if id != nil {
                                
                                // save user information we received from our host
                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                
                                
                                // go to tabbar / home page
                                 DispatchQueue.main.async(execute: {
                                 appDelegate.register()
                                 })
                                
                                // error
                            } else {
                                
                                /*// get main queue to communicate back to user
                                 DispatchQueue.main.async(execute: {
                                 let message = parseJSON["message"] as! StringappDelegate.infoView;(message: message, color: colorSmoothRed)
                                 })*/
                                return
                                
                            }*/
                            
                            DispatchQueue.main.async(execute: {
                                appDelegate.register()
                            })
                            
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
    
    
    // white status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    // touched screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // hide keyboard
        self.view.endEditing(false)
    }
    
    
}

