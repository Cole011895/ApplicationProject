//
//  ReportVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ReportVC: UIViewController, UITextViewDelegate {
    var tutorName: String!
    var date: String!
    
    @IBOutlet weak var appDate: UILabel!
    @IBOutlet weak var tutorTxt: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentText.delegate = self
        commentText.text = "Comment:"
        commentText.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        
        print(tutorName)
        print(date)
        
        tutorTxt.text = tutorName
        appDate.text = date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentText.textColor == UIColor.lightGray{
            commentText.text = nil
            commentText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentText.text.isEmpty{
            commentText.text = "Comment:"
            commentText.textColor = UIColor.lightGray
        }
    }
    
    //closes keyboard when return is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    @IBAction func submitClick(_ sender: Any) {
        report()
        appDelegate.student_login()
    }
    
    
    func report(){
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/reportTutor.php")!
        
        // declare request to proceed php file
        var request = URLRequest(url: url)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        let userID = user!["UID"] as? String
        
        // body to be appended to url
        let body = "TutorName=\(tutorTxt.text!)&UserID=\(userID!)&Message=\(commentText.text!)"
        
        request.httpBody = body.data(using: .utf8)
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {
                
                // no error of accessing php file
                if error == nil {
                    /*
                     do {
                     
                     
                     // getting content of $returnArray variable of php file
                     let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Dictionary<String, Any>]
                     
                     
                     // declare new parseJSON to store json
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
                     }*/
                    
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

 

}
