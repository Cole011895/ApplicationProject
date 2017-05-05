//
//  ManageStudentVC.swift
//  Testing
//
//  Created by Garrett Lee on 4/16/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ManageStudentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.text = user?["Fullname"] as? String
        self.emailTextField.text = user?["Email"] as? String
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        
    }
    
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
    
    
    @IBAction func updatePressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || nameTextField.text!.isEmpty {
            //red placeholders
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
            
            
            //if email address not in valid format
        else if isValidEmail(testStr: emailTextField.text!) == false{
            DispatchQueue.main.async(execute: {
                let message = "Bad email"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
            
        }
        else {
            let userID = user?["UID"]
            let name = self.nameTextField.text?.replacingOccurrences(of: " ", with: "%20")
            let email = self.emailTextField.text
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/updateStudent.php?id=\(userID!)&email=\(email!)&fullname=\(name!)")!
            
            // request to this file
            var request = URLRequest(url: url)
            
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            
            // proceed request
            URLSession.shared.dataTask(with: request) { data, response, error in
                /*
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
                */
                // launch prepared session
                }.resume()
            
            let url2 = URL(string: "http://cgi.soic.indiana.edu/~team55/login.php")!
            
            var request2 = URLRequest(url: url2)
            
            request2.httpMethod = "POST"
            
            let body2 = "Email=\(user!["Email"]!)&Password=\(user!["Password"]!)"
            
            request2.httpBody = body2.data(using: .utf8)
            
            // launch session
            URLSession.shared.dataTask(with: request2) { data, response, error in
                
                // no error
                if error == nil {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        
                        let id = parseJSON["UID"] as? String
                        
                        // successfully logged in
                        if id != nil {
                            
                            // save user information we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            
                            print(1)
                            print(user)
                            print(2)
                            
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

            let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated. Please log out and log back in to see the changes take place.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
