//
//  ManageTutorVC.swift
//  Testing
//
//  Created by Garrett Lee on 4/17/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ManageTutorVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var primaryClassText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var info = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.majorText.delegate = self
        self.bioText.delegate = self
        self.yearText.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadInfo()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        bioText.text = nil
        
    }
    
    //closes keyboard when return is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    
    func convertMessage(message: String)->String{
        var newMessage = message.replacingOccurrences(of: " ", with: "%20")
        newMessage = newMessage.replacingOccurrences(of: "'", with: "%5C%27")
        newMessage = newMessage.replacingOccurrences(of: "\"", with: "%5C%22")
        newMessage = newMessage.replacingOccurrences(of: "\\", with: "%5C%5C")
        newMessage = newMessage.replacingOccurrences(of: "%", with: "%25")
        newMessage = newMessage.replacingOccurrences(of: "^", with: "%5E")
        newMessage = newMessage.replacingOccurrences(of: "&", with: "%26")
        newMessage = newMessage.replacingOccurrences(of: "+", with: "%2B")
        newMessage = newMessage.replacingOccurrences(of: "{", with: "%7B")
        newMessage = newMessage.replacingOccurrences(of: "}", with: "%7D")
        newMessage = newMessage.replacingOccurrences(of: "|", with: "%7C")
        newMessage = newMessage.replacingOccurrences(of: "<", with: "%3C")
        newMessage = newMessage.replacingOccurrences(of: ">", with: "%3E")
        newMessage = newMessage.replacingOccurrences(of: "`", with: "%60")
        return newMessage
    }
    
    func loadInfo() {
        let userID = user?["UID"]
        
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullManageTutor.php?id=\(userID!)")
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
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Dictionary<String, Any>]
                        
                        // clean up
                        self.info.removeAll(keepingCapacity: false)
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.info = parseJSON
                        print("hey \(self.info)")
                        let tutorInfo = self.info[0]
                        self.nameTextField.text = tutorInfo["Fullname"] as? String!
                        self.emailTextField.text = tutorInfo["Email"] as? String!
                        self.bioText.text = tutorInfo["Bio"] as? String!
                        self.primaryClassText.text = tutorInfo["Classes"] as? String!
                        self.majorText.text = tutorInfo["Major"] as? String!
                        self.yearText.text = tutorInfo["Year"] as? String!
                        
                        
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
    
    @IBAction func updatePressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || nameTextField.text!.isEmpty || bioText.text!.isEmpty || primaryClassText.text!.isEmpty || majorText.text!.isEmpty || yearText.text!.isEmpty {
            //red placeholders
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            primaryClassText.attributedPlaceholder = NSAttributedString(string: "Class", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            majorText.attributedPlaceholder = NSAttributedString(string: "Major", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            yearText.attributedPlaceholder = NSAttributedString(string: "Year", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
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
            let bio = convertMessage(message: self.bioText.text!)
            let course = convertMessage(message: self.primaryClassText.text!)
            let major = self.majorText.text
            let year = self.yearText.text
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/updateTutor.php?id=\(userID!)&email=\(email!)&fullname=\(name!)&bio=\(bio)&class=\(course)&major=\(major!)&year=\(year!)")!
            
            // request to this file
            var request = URLRequest(url: url)
            
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            
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
            let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated. Please log out and log back in to see the changes take place.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
