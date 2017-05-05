//
//  ChatAvailableViewController.swift
//  Testing
//
//  Created by Coleman Hedges on 4/4/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ChatAvailableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var tableview: UITableView!
    var tutors = [Dictionary<String, Any>]()
    
    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call funcuntion for loading tutors
        loadTutors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! ChatAvailableTVC
        
        //get a tutor and all of his/her information into the cell
        
        var tutor = Dictionary<String,Any>()
        
        tutor = tutors[indexPath.row]
        
        let name = tutor["Fullname"] as? String
        let tutorID = tutor["UID"] as? Int
        let ava = tutor["Ava"] as? String
        
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
                        cell.photo.image = UIImage(data: imageData!)
                        cell.tutorPhoto = UIImage(data: imageData!)
                    })
                }
            })
            
        }else{
            cell.photo.image = #imageLiteral(resourceName: "ava.png")
            cell.tutorPhoto = #imageLiteral(resourceName: "ava.png")
        }
        
        cell.name.text = name
        cell.tutorID = tutorID
        
        return cell
        
    }
    
    
    func loadTutors() {
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullTutors.php")!
        
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
                        
                        // clean up
                        self.tutors.removeAll(keepingCapacity: false)
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.tutors = parseJSON as [Dictionary<String, Any>]
                        self.tutors = self.tutors.sorted(by: {$1["Rate"] as! Float > $0["Rate"] as! Float})
                        
                        self.tableview.reloadData()
                        
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageSegue" {
            if let detailsVC = segue.destination as? ChatViewController {
                if let tutor = sender as? ChatAvailableTVC {
                    detailsVC.tutorID = tutor.tutorID
                    detailsVC.images = tutor.tutorPhoto
                }
            }
        }
        
    }
    
    
    
}
