//
//  ViewController_two.swift
//  Testing
//
//  Created by Coleman Hedges on 2/4/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit



class MessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var maincontraint: NSLayoutConstraint!
    var refresh: UIRefreshControl = UIRefreshControl()
    var rooms = [Dictionary<String, Any>]()
    var lastMessages = [Dictionary<String, Any>]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rooms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = tableview.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessagesTVC
        
        let ava = rooms[indexPath.row]["Ava"] as! String
        
        if ava != "" {
            
            // url path to image
            let imageURL = URL(string: ava)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        message.messphoto.image = UIImage(data: imageData!)
                        message.images = UIImage(data: imageData!)
                    })
                }
            })
            
        }else{
            message.messphoto.image = #imageLiteral(resourceName: "ava.png")
            message.images = #imageLiteral(resourceName: "ava.png")
        }
        
        message.tutorID = rooms[indexPath.row]["UID"] as! Int?
        
        message.messname.text = rooms[indexPath.row]["Fullname"] as! String?
        
        let userID = user?["UID"] as? Int
        
        let mess = lastMessages[indexPath.row]["Message"] as! String?
        
        if lastMessages[indexPath.row]["SenderID"] as? Int != userID {
        message.messmessage.text = "You: \(mess!)"
        } else{
            message.messmessage.text = mess!
        }
        return message
    }
    
    var menu = false
    
    @IBAction func menuitem(_ sender: Any) {
        if (menu){
            maincontraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            })
        }else{
            maincontraint.constant = -240
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            })
        }
        menu = !menu
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        refresh.tintColor = UIColor.red
        tableview.dataSource = self
        refresh.addTarget(self, action: #selector(MessagesVC.loadRooms), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *){
            tableview.refreshControl = refresh
        }else{
            tableview.addSubview(refresh)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    //This allows for only registered users to view the page. Requires them to log in first
    override func viewWillAppear(_ animated: Bool) {
        if user == nil {
            let slogin = self.storyboard?.instantiateViewController(withIdentifier: "StudentLoginVC") as! StudentLoginVC
            self.present(slogin, animated: true, completion: nil)
        }
        
        loadRooms()
        
    }
    
    func loadRooms() {

        
        var userID = user?["UID"]
        
        if userID == nil {
            userID = 33
        }
        
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullRoomsTutor.php?id=\(userID!)")
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
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[Dictionary<String, Any>]]
                        
                        // clean up
                        self.rooms.removeAll(keepingCapacity: false)
                        
                        self.tableview.reloadData()
                   
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.rooms = parseJSON[0]
                        self.lastMessages = parseJSON[1]
                        
                        // reload tableView to show back information
                        self.tableview.reloadData()
                        self.refresh.endRefreshing()
                    
                        
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
        if segue.identifier == "roomSegue" {
            if let threadVC = segue.destination as? ChatViewController {
                if let room = sender as? MessagesTVC {
                    threadVC.tutorID = room.tutorID
                    threadVC.images = room.images
                }
            }
        }
        
    }
    
}
