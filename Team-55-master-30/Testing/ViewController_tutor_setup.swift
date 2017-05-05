//
//  ViewController_tutor_setup.swift
//  Testing
//
//  Created by Coleman Hedges on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ViewController_tutor_setup: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate{
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var gradeTxt: UITextField!
    @IBOutlet weak var rateTxt: UITextField!
    @IBOutlet weak var bioText: UITextView!
    var pickOption = ["Informatics", "Fine Arts", "Law", "Business", "Sociology", "Nursing", "Neuroscience", "Computer Science", "Accounting", "Art History", "Music Studies","Game Design", "Gender Studies", "Engineering"]
    var pickOption_grade = ["Freshmen", "Sophmore", "Junior", "Senior"]
    
    var ammount: Int = 0

    //@IBOutlet weak var img: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bioText.delegate = self
        bioText.text = "Comment:"
        
        /*
        
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true*/

        // Do any additional setup after loading the view.
        bioText!.layer.borderWidth = 1
        bioText!.layer.borderColor = UIColor.white.cgColor
        var grade = UIPickerView()
        var major = UIPickerView()
        /*    pickerView.delegate = self */
        grade.delegate = self
        major.delegate = self
        
        
        /*    pickerView.tag = 2 */
        grade.tag = 1
        major.tag = 0
        let email = user!["Email"] as? String
        let fullname = user!["Fullname"] as? String
        //let ava = user!["Ava"] as? String
        
        
        emailLbl.text = email
        fullnameLbl.text = fullname
        
        self.majorTxt.delegate = self;
        self.gradeTxt.delegate = self;
        self.rateTxt.delegate = self;
        self.bioText.delegate = self;
        rateTxt.placeholder = updateAmount()
        rateTxt.tag = 2
        gradeTxt.inputView = grade
        majorTxt.inputView = major
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.tintColor = UIColor.red
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(addscheduleVC.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 17)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor(red: 220.0, green: 20.0, blue: 60.0, alpha: 1.0)
        
        label.text = "Subject"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        majorTxt.inputAccessoryView = toolBar
        gradeTxt.inputAccessoryView = toolBar
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            bioText.text = nil
            
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if let digit = Int(string){
            ammount = ammount * 10 + digit
            
            if ammount > 1_00_00 {
                let alarm = UIAlertController(title: "Please enter amount less than 100", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                
                alarm.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
                present(alarm, animated:true, completion:nil)
                rateTxt.text = ""
                ammount = 0
            }else{
                rateTxt.text = updateAmount()
            }
            
        
        }
        if string == ""{
            ammount = ammount/10
            rateTxt.text = ammount == 0 ? "": updateAmount()
        }
        return false
        
        
    }
    func updateAmount() ->String?{
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.currency
        let amt = Double(ammount/100) + Double(ammount%100)/100
        return format.string(from: NSNumber(value:amt))
    }
    @available(iOS 2.0, *)
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return pickOption_grade.count
        }
        else if pickerView.tag == 0{
            return pickOption.count
        }
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return pickOption_grade[row]
        }
        else {
            return pickOption[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            gradeTxt.text = pickOption_grade[row]
        }
            
        else {
            majorTxt.text = pickOption[row]
        }
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        majorTxt.resignFirstResponder()
        gradeTxt.resignFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //This allows for whenever you hit the Return key on the key board, the keyboard will disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            bioText.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func submit_click(_ sender: Any) {
        let d1 = UIImagePNGRepresentation(avaImg.image!)
        let d2 = UIImagePNGRepresentation(#imageLiteral(resourceName: "ava.png"))
        
        let alert = UIAlertController(title: "Congrats!", message: "You now have access to your tutor interface. Once you are verified, you can conduct tutoring sessions with other students", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        
        //checking for empty fields
        if majorTxt.text!.isEmpty || gradeTxt.text!.isEmpty || rateTxt.text!.isEmpty || bioText.text!.isEmpty{
            // get main queue to communicate back to user
            DispatchQueue.main.async(execute: {
                let message = "Please enter all fields"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
        }
            
        //check if ava image is selected
        else if d1! == d2!{
            // get main queue to communicate back to user
            DispatchQueue.main.async(execute: {
                let message = "Please select a profile picture"
                appDelegate.infoView(message: message, color: colorSmoothRed)
            })
        }
        
        
            
        else{
            // remove keyboard
            self.view.endEditing(true)
            
            // url to php file
            let url = URL(string: "http://cgi.soic.indiana.edu/~team55/registerTutor2.php")!
            let url2 = URL(string: "http://cgi.soic.indiana.edu/~team55/login.php")!
            
            // request to this file
            var request = URLRequest(url: url)
            var request2 = URLRequest(url: url2)
            
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            request2.httpMethod = "POST"
            
            // body to be appended to url
            let body = "Bio=\(bioText.text!)&Rate=\(rateTxt.text!)&Major=\(majorTxt.text!)&Year=\(gradeTxt.text!)&UID=\(user!["UID"]!)"
            let body2 = "Email=\(user!["Email"]!)&Password=\(user!["Password"]!)"
            
            request.httpBody = body.data(using: .utf8)
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
                            self.present(alert, animated: true, completion: nil)
                            
                            
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
            
            
            
            
            
            
            // proceed request
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                print("test")
                
                
                // launch prepared session
                }.resume()

    }
        
        
 
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    @IBAction func edit_click(_ sender: Any) {
        
        //select ava
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    //selected img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // call func of uploading file to server
        uploadAva()
    }
    
    
    // custom body of HTTP request to upload image file
    func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
        
    }
    
    
    //upload image to server
    func uploadAva() {
        
        // shotcut id
        let id = user!["UID"] as! String
        
        // url path to php file
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/uploadAva.php")!
        
        // declare request to this file
        var request = URLRequest(url: url)
        
        // declare method of passign inf to this file
        request.httpMethod = "POST"
        
        // param to be sent in body of request
        let param = ["UID" : id]
        
        // body
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // compress image and assign to imageData var
        let imageData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        
        // if not compressed, return ... do not continue to code
        if imageData == nil {
            return
        }
        
        // ... body
        request.httpBody = createBodyWithParams(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        // launc session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to communicate back to user
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        // json containes $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        //************Overwrite the users 'Tutor' attribute to 1********************
                        /*
                        // get id from $returnArray["id"] - parseJSON["id"]
                        let id = parseJSON["UID"]
                        
                        // successfully uploaded
                        if id != nil {
                            
                            // save user information we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            
                            // did not give back "id" value from server
                        } else {
                            
                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            
                        }*/
                        
                        // error while jsoning
                    } catch {
                        
                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = error as! String
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        
                    }
                    
                    // error with php
                } else {
                    
                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    
                }
                
                
            })
            
            }.resume()
        
        
    }//end of uploadAva()
    



}


// Creating protocol of appending string to var of type data
extension NSMutableData {
    
    func appendString(_ string : String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
        
    }
    
    
}




    
    
    
    
    
    
    



