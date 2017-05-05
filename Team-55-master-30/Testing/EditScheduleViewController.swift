//
//  EditScheduleViewController.swift
//  Testing
//
//  Created by Coleman Hedges on 4/10/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//
import UIKit

class EditScheduleViewController: UIViewController, UIPickerViewDelegate {
    
    var date: Date!
    
    @IBOutlet weak var validText2: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var weekNum: UITextField!
    @IBOutlet weak var validText: UILabel!
    var userID = user?["UID"]
    @IBOutlet weak var end_time: UITextField!
    @IBOutlet weak var first_time: UITextField!
/*    @IBOutlet weak var checkbox: UIButton!*/
    var boxon = UIImage(named:"check")
    var boxoff = UIImage(named: "uncheck")
    var startDate: Date!
    var endTime: Date!
    var boxclicked:Bool!
    var initialStart: String!
    var initialEnd: String!
    var availID: Int!
    
    
    @IBAction func timer2(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        datePickerView.minuteInterval = 60
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EditScheduleViewController.endpicker), for: UIControlEvents.valueChanged)
    }
    
    func endpicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        endTime = sender.date
        end_time.text = dateFormatter.string(from: sender.date)
        
        if (sender.date <= startDate) || (sender.date <= endTime)  {
            validText.text = "Your times are invalid"
        }
        else {
            validText.text = ""
        }
        
    }
    @IBAction func time(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EditScheduleViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        startDate = sender.date
        first_time.text = dateFormatter.string(from: sender.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateText.text = dateFormatter.string(from: date)
        boxclicked = false
        first_time.text = initialStart
        end_time.text = initialEnd
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.tintColor = UIColor.red
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EditScheduleViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 17)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor(red: 220.0, green: 20.0, blue: 60.0, alpha: 1.0)
        
        label.text = "Time"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        
        first_time.inputAccessoryView = toolBar
        end_time.inputAccessoryView = toolBar
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
  /*  @IBAction func box(_ sender: Any) {
        if boxclicked == true{
            boxclicked = false
        }
        else{
            boxclicked = true
        }
        if boxclicked == true{
            checkbox.setImage(boxon, for: UIControlState.normal)
            
        }
        else{
            checkbox.setImage(boxoff, for: UIControlState.normal)
        }
    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        
        first_time.resignFirstResponder()
        end_time.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        formatter.dateFormat = "hh:mm:ss"
        print("Start: \(startDate!) End: \(endTime!)")
        let start = formatter.string(from: startDate!)
        let end = formatter.string(from: endTime!)
        print("1 \(availID!) 2 \(userID!) 3 \(initialStart!) 4 \(initialEnd!) 5 \(start) 6 \(end) 7 \(dateString)")
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/editSchedule.php?AvailableID=\(availID!)&TutorID=\(userID!)&initStart=\(initialStart!)&initEnd=\(initialEnd!)&newStart=\(start)&newEnd=\(end)&Date=\(dateString)")
        // declare request to proceed php file
        // request to this file
        var request = URLRequest(url: url!)
        
        // method to pass data to this file (e.g. via POST)
        request.httpMethod = "POST"
        
        
        // proceed request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // launch prepared session
            }.resume()
        
        navigationController?.popViewController(animated: true)
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
