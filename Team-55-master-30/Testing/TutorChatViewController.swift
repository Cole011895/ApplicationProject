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
    static let cellMessageRecieved = "tutorYou"
    static let cellMessageSent = "tutorMe"
}
class TutorChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableviews: UITableView!
    @IBOutlet weak var chatTextFieldtwo: UITextField!
    
    var message = [[0,1,"Hey Whats up"], [1,0,"Nothin u?"], [0,1, "Lets meet up"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        chatTextFieldtwo.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in})

        // Do any additional setup after loading the view.
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

    
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.message.count-1, section: 0)
            self.tableviews.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
   
   
    @IBAction func SendMessagetwo(_ sender: Any) {
        let alert = UNMutableNotificationContent()
        alert.title = "The message has been sent"
        alert.subtitle = "They are up now!"
        alert.body = "Its is up now"
        alert.badge = 1
        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats:false)
        let req = UNNotificationRequest(identifier: "timedone", content: alert, trigger: trig)
        self.chatTextFieldtwo.resignFirstResponder()
        if chatTextFieldtwo.text != "" {
            self.message.append([1,0,self.chatTextFieldtwo.text!])
            
            self.chatTextFieldtwo.text = nil
            tableviews.reloadData()
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
            self.scrollToBottom()
            
        }
        else{
            print("Error:Empty String")
        }
    }

    let nam = ["Hello", "Beyonce"]
    let nam2 = ["Hello", "Wow"]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableviews.estimatedRowHeight = 90.0
        tableviews.rowHeight = UITableViewAutomaticDimension
        if message[indexPath.row][0] as? Int == 0 {
            let cell = tableviews.dequeueReusableCell(withIdentifier: "tutorYou", for: indexPath) as! TutorChatTableViewCell
            cell.TutorMessagehim.text = message[indexPath.row][2] as? String
            return cell
        }
        else {
            let cell = tableviews.dequeueReusableCell(withIdentifier: "tutorMe", for: indexPath) as! TutorChatMeTableViewCell
            cell.TutorMessageMe.text = message[indexPath.row][2] as? String
            
            return cell
            //set the data here
            
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
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
