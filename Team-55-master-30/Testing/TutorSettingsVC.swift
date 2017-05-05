//
//  TutorSettingsVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorSettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet var another_tableview: UITableView!
    
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
        
        
        
        if user != nil{
        let ava = user!["Ava"] as? String
        
        
        
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

        
    

    let identities = ["homevc","1","2","3","4","6", "7"]
    let selections = ["Return as a Student","Manage Account", "Help","Past Appointments", "Contact", "Payment Settings", "Select Classes"]
    
    
    func tableView(_ another_tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ another_tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let select = another_tableview.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SettingsTVC
        select.selection_start.text = selections[indexPath.row]
        return select
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let new_name = identities[indexPath.row]
        if new_name == "homevc"{
            appDelegate.student_login()
        }else{
        let view = storyboard?.instantiateViewController(withIdentifier: new_name)
        self.navigationController?.pushViewController(view!, animated: true)
        }
    }
    
}
