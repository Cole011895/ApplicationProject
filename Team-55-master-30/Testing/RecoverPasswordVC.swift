//
//  RecoverPasswordVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class RecoverPasswordVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTxt.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func submitClick(_ sender: Any) {
        
        if emailTxt.text!.isEmpty {
            //red placeholders
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.red])

        }else{
        self.view.endEditing(true)
        
        let email = emailTxt.text!
        
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/resetPassword.php")!
        
        // request url
        var request = URLRequest(url: url)
        
        // method to pass data POST - cause it is secured
        request.httpMethod = "POST"
        
        // body gonna be appended to url
        let body = "email=\(email)"
        
        // append body to our request that gonna be sent
        request.httpBody = body.data(using: .utf8)
            

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let alert = UIAlertController(title: "Email Sent", message: "Please check your email for a recovery link", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.async(execute: {
                appDelegate.student_login()
            })
            }.resume()

        }

    }



}
