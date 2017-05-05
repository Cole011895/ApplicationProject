//
//  TutorHomeVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorHomeVC: UIViewController {
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                        
                        
                        /*
                         // go to tabbar / home page
                         DispatchQueue.main.async(execute: {
                         appDelegate.login()
                         })*/
                        
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
    
    
    
    
    
    
    //clicked logout button
    @IBAction func logout_click(_ sender: Any) {
        
        // remove saved information
        UserDefaults.standard.removeObject(forKey: "parseJSON")
        UserDefaults.standard.synchronize()
        user = nil
        // go to login page
        let landingvc = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
        self.present(landingvc, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
}
