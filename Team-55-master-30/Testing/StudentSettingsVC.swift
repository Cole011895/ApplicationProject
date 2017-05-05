//
//  ViewController_three.swift
//  Testing
//
//  Created by Coleman Hedges on 2/13/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentSettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet var another_tableview: UITableView!
    
    @IBOutlet weak var testLbl: UILabel!
    

    
    
    //This allows for only registered users to view the page. Requires them to log in first
    override func viewWillAppear(_ animated: Bool) {
        if user == nil {
            
            let slogin = self.storyboard?.instantiateViewController(withIdentifier: "StudentLoginVC") as! StudentLoginVC
            self.present(slogin, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tapGestureRecognizer)
        
        
        //testing log in info is being saved
        if user != nil {
            let name = user!["Fullname"] as? String
            testLbl.text = name
        }else{
            testLbl.text = ""
        }
        
        if user != nil{
            let ava = user!["Ava"] as? String
            //let tutorStatus = user!["Tutor"] as? String
            //print(tutorStatus!)
            
            
            // get user profile picture
            if ava != "" {
                
                // url path to image
                let imageURL = URL(string: ava!)!
                
                // communicate back user as main queue
                DispatchQueue.main.async(execute: {
                    
                    // get data from image url
                    let imageData = try? Data(contentsOf: imageURL)
                    
                    // if data is not nill assign it to ava.Img
                    if imageData != nil {
                        DispatchQueue.main.async(execute: {
                            self.img.image = UIImage(data: imageData!)
                        })
                    }
                })
                
            }
        }
        
        
        
    }
    
    
    //******************Change profile picture***********************
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImage
        print("success")
        
        //select ava
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    //selected img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        img.image = info[UIImagePickerControllerEditedImage] as? UIImage
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
        let imageData = UIImageJPEGRepresentation(img.image!, 0.5)
        
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

    
    //******************Change profile picture***********************



    
    
    //let identities = ["RegTutor","A","B","C","D","E"]
    //let selections = ["Register as a tutor","Manage Account", "Help","Past Appointments", "Contact","Notifications"]
    
    
    func tableView(_ another_tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ another_tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if user != nil{
        let tutorStatus = user!["Tutor"] as? String
        
        if tutorStatus! == "0"{
            let selections = ["Register as a tutor","Manage Account", "Help","Past Appointments", "Contact","Notifications"]
            
            let select = another_tableview.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SettingsTVC
            select.selection_start.text = selections[indexPath.row]
            return select
            
        }else{
            let selections = ["My Tutoring Page","Manage Account", "Help","Past Appointments", "Contact","Notifications"]
            let select = another_tableview.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SettingsTVC
            select.selection_start.text = selections[indexPath.row]
            return select
        }
        }else{
            //this is called just so an error will not appear before the ViewWillAppear function
            let selections = ["Register as a tutor","Manage Account", "Help","Past Appointments", "Contact","Notifications"]
            
            let select = another_tableview.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SettingsTVC
            select.selection_start.text = selections[indexPath.row]
            return select
        }
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tutorStatus = user!["Tutor"] as? String
        
        //not a tutor
        if tutorStatus! == "0"{
            let identities = ["RegTutor","A","B","C","D","E"]
            
        let new_name = identities[indexPath.row]
            
        //go to tutor registration if first row is clicked
        if new_name == "RegTutor"{
            appDelegate.register_tutor()
        }else{
        let view = storyboard?.instantiateViewController(withIdentifier: new_name)
        self.navigationController?.pushViewController(view!, animated: true)
            }
        } else{
            //is a tutor
            let identities = ["TutorSwitch","A","B","C","D","E"]
            
            let new_name = identities[indexPath.row]
            if new_name == "TutorSwitch"{
                //go to tutor homepage
                appDelegate.login()
            }else{
                let view = storyboard?.instantiateViewController(withIdentifier: new_name)
                self.navigationController?.pushViewController(view!, animated: true)
            }
            
        }
    }
    

    
}



