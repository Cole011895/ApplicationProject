//
//  RegisterTutorVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class RegisterTutorVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var firstnameTxt: UITextField!
    
    @IBOutlet weak var lastnameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var confirmTxt: UITextField!
    
    var emails = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.emailTxt.delegate = self;
        self.firstnameTxt.delegate = self;
        self.lastnameTxt.delegate = self;
        self.passwordTxt.delegate = self;
        self.confirmTxt.delegate = self;
        self.loadEmails()
    }
    
    
    //This allows for whenever you hit the Return key on the key board, the keyboard will disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
    func loadEmails(){
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullUsersEmails.php")!
        
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
                        
                        
                        self.emails = parseJSON as [Dictionary<String, Any>]
                        
                        
                        
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

    
    

    @IBAction func register_click(_ sender: Any) {
        
        //this checks to see if the email address was already registered
        for var i in (0..<self.emails.count){
            if self.emails[i]["Email"] as? String == emailTxt.text!{
                DispatchQueue.main.async(execute: {
                    let message = "Email has already been registered"
                    appDelegate.infoView(message: message, color: colorSmoothRed)
                })
                return
            }
            
            
        }
        
        //Validation
        
        
        //if no text
        if emailTxt.text!.isEmpty || firstnameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || confirmTxt.text!.isEmpty {
            //red placeholders
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            firstnameTxt.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            lastnameTxt.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            confirmTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
            
        //if Confirm Password is different than Password entered
        else if passwordTxt.text! != confirmTxt.text!{
            DispatchQueue.main.async(execute: {
                let message = "Not the same password"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
        }
        
        //if email address not in valid format
        else if isValidEmail(testStr: emailTxt.text!) == false{
            DispatchQueue.main.async(execute: {
                let message = "Bad email"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
            
        }
            
            
        else{
            // remove keyboard
            self.view.endEditing(true)
            
            // url to php file
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/registerCT2.php")!
            
            // request to this file
            var request = URLRequest(url: url)
            
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            
            // body to be appended to url
            let body = "Password=\(passwordTxt.text!)&Email=\(emailTxt.text!)&Fullname=\(firstnameTxt.text!)%20\(lastnameTxt.text!)"
            
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
                            let id = parseJSON["UID"]
                            
                            // successfully registered
                            if id != nil {
                                
                                // save user information we received from our host
                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                
                                // go to tabbar / home page
                                DispatchQueue.main.async(execute: {
                                    appDelegate.student_register()
                                })
                                
                                // error
                            } else {
                                
                                /*// get main queue to communicate back to user
                                 DispatchQueue.main.async(execute: {
                                 let message = parseJSON["message"] as! StringappDelegate.infoView;(message: message, color: colorSmoothRed)
                                 })*/
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

