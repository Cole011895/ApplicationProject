//
//  ChatViewController.swift
//  Testing
//
//  Created by Coleman Hedges on 3/26/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit
import UserNotifications
private struct Constants{
    static let cellMessageRecieved = "Messagehim"
    static let cellMessageSent = "MessageMe"
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
 
    var messages = [Dictionary<String, Any>]()
    
    
    let userID = user?["UID"]! as! String
    
    var tutorID: Int!
    var images: UIImage!
    var myImage = #imageLiteral(resourceName: "ava.png")
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        self.messages = [["SenderID": 0, "Message": "Send your first message!"]]
        loadMessages()
        loadMyPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in})
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        chatTextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
       
   
        print(userID)
        print(tutorID)
    }
    func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    func adjustingHeight(_ show:Bool, notification:Notification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + -50) * (show ? 1 : -1)
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        
        
    }
    
    func textFieldShouldReturn(_ chatTextField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ChatViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            
            self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        let alert = UNMutableNotificationContent()
        alert.title = "You sent a message"
        alert.subtitle = "It is up now!"
        alert.badge = 1
        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats:false)
        let req = UNNotificationRequest(identifier: "timedone", content: alert, trigger: trig)
        
        self.chatTextField.resignFirstResponder()
        if chatTextField.text != "" {
            sendAMessage()
            
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.loadMessages()
                self.scrollToBottom(
                UNUserNotificationCenter.current().add(req, withCompletionHandler: nil))
            }
            
            self.chatTextField.text?.removeAll()
            

        }else{
            print("Error:Empty String")
        }
        
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
    
    func sendAMessage() {
        
        let message = convertMessage(message: chatTextField.text!)
        
        let str = "http://cgi.soic.indiana.edu/~team55/sendMessage.php?Message=\(message)&SenderID=\(userID)&RecipientID=\(tutorID!)"
        
        let url = URL(string: str)
        
        // request to this file
        var request = URLRequest(url: url!)
        
        // method to pass data to this file (e.g. via POST)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {
                
                // no error of accessing php file
                if error == nil {
                    
                    do {
                        
                        // getting content of $returnArray variable of php file
                        let _ = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String,String>
                        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if messages[indexPath.row]["SenderID"] as? Int == Int(userID) {
            let cell = tableview.dequeueReusableCell(withIdentifier: "MessagesYou", for: indexPath) as! ChatTableViewCell
            cell.Messagehim.text = messages[indexPath.row]["Message"] as? String
            cell.photo_one.image = self.myImage
            return cell
        }
            
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "MessagesMe", for: indexPath) as! ChatMeTableViewCell
            cell.MessageMe.text = messages[indexPath.row]["Message"] as? String
            cell.me.image = self.images
            
            return cell
            //set the data here
            
        }
    }
    
    func loadMyPhoto(){
        let ava = user?["Ava"] as! String
        
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
                       self.myImage = UIImage(data: imageData!)!
                    })
                }
            })
            
        }
    }
    
    func loadMessages(){
    
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullMessages.php?StudentID=\(userID)&TutorID=\(tutorID!)")
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
                        self.messages.removeAll(keepingCapacity: false)
                   
                        self.tableview.reloadData()
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        self.messages = parseJSON
                        
                        // reload tableView to show back information
                        self.tableview.reloadData()
                        
                    } catch {
            
                            
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
    
    /* extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
     func tableview(tableview: UITableView, cellForRowAtIndexPath IndexPat: NSIndexPath) -> UITableViewCell{
     let messageSnap = messages[IndexPath.row]
     let message = messageSnap.value as Dictionary<String,AnyObject>
     let message
     let cell = tableview.dequeueReusableCell(withIdentifier: Constants.cellMessageSent, for: <#T##IndexPath#> as !ChatTableViewCell)
     cell.configCell(Mess)
     }
     }
     */
    
}
