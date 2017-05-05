//
//  LoginVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorLoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.emailTxt.delegate = self;
        self.passwordTxt.delegate = self;
    }
    
    
    //This allows for whenever you hit the Return key on the key board, the keyboard will disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    @IBAction func login_click(_ sender: Any) {
        
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red placeholders
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.red])
    
        }else{
            
            // remove keyboard
            self.view.endEditing(true)
            
            // shortcuts
            let email = emailTxt.text!
            let password = passwordTxt.text!
            
            // send request to mysql db
            // url to access our php file
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/login.php")!
            
            // request url
            var request = URLRequest(url: url)
            
            // method to pass data POST - cause it is secured
            request.httpMethod = "POST"
            
            // body gonna be appended to url
            let body = "Email=\(email)&Password=\(password)"
            
            // append body to our request that gonna be sent
            request.httpBody = body.data(using: .utf8)
            
            // launch session
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                // no error
                if error == nil {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        // remove keyboard
                        
                        
                        let id = parseJSON["UID"] as? String
                        
                        // successfully logged in
                        if id != nil {
                            
                            // save user information we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            
                            // go to tabbar / home page
                            DispatchQueue.main.async(execute: {
                                appDelegate.login()
                            }) 
                            
                            // error
                        } else {
                            
                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
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
                    
                } else {
                    
                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return
                    
                }
                
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
