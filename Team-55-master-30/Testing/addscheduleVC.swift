//
//  addscheduleVC.swift
//  Testing
//
//  Created by Coleman Hedges on 2/27/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//


import UIKit

class addscheduleVC: UIViewController, UIPickerViewDelegate {
    
    var date: Date!
    
    @IBOutlet weak var weekNum: UITextField!
    @IBOutlet weak var validText: UILabel!
    
    @IBOutlet weak var validText2: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var end_time: UITextField!
    @IBOutlet weak var first_time: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    var boxon = UIImage(named:"check")
    var boxoff = UIImage(named: "uncheck")
    var startDate: Date!
    var userID = user?["UID"]
    var boxclicked:Bool!
    var endTime: Date!
    
    
    @IBAction func timer2(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        datePickerView.minuteInterval = 60
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(addscheduleVC.endpicker), for: UIControlEvents.valueChanged)
    }
    
    func endpicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        endTime = sender.date
        end_time.text = dateFormatter.string(from: sender.date)
        
        if (sender.date <= startDate) {
            validText.text = "Your times are invalid"
        } else {
            validText.text = ""
        }
        
    }
    @IBAction func time(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(addscheduleVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
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
        
        label.text = "Time"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        
        first_time.inputAccessoryView = toolBar
        end_time.inputAccessoryView = toolBar
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func box(_ sender: Any) {
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
    }
    
    
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
        var weeks = -1
        
        if !boxclicked {
            weeks = 0
        }
        if (boxclicked && (Int(weekNum.text!) != nil)) {
            weeks = Int(weekNum.text!)! - 1
        }
        // remove keyboard
        if (weeks != -1) {
            var instantDate = date
            for i in 0...weeks {
                self.view.endEditing(true)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: instantDate!)
                
                formatter.dateFormat = "hh:mm:ss"
                let start = formatter.string(from: startDate!)
                let end = formatter.string(from: endTime!)
                // url to php file
                
                let url = URL(string: "http://cgi.soic.indiana.edu/~team55/addSchedule.php?TutorID=\(userID!)&Start=\(start)&End=\(end)&Date=\(dateString)")!
                
                // request to this file
                var request = URLRequest(url: url)
                
                // method to pass data to this file (e.g. via POST)
                request.httpMethod = "POST"
                
                
                // proceed request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    // launch prepared session
                    }.resume()
                
                let currCalendar = Calendar.current
                var currentMonth = currCalendar.component(.month, from: instantDate!)
                let totalDays = (currCalendar.range(of: .day, in: .month, for: instantDate!)!).count
                var currentDay = currCalendar.component(.day, from: instantDate!)
                var currentYear = currCalendar.component(.year, from: instantDate!)
                
                var possibleDay = currentDay + 7
                
                if possibleDay > totalDays {
                    possibleDay = possibleDay - totalDays
                    if currentMonth == 12 {
                        currentYear += 1
                        currentMonth = 1
                    } else {
                        currentMonth += 1
                    }
                }
                
                currentDay = possibleDay
                instantDate = currCalendar.date(from: DateComponents(year: currentYear, month:currentMonth, day: currentDay))
            }
            
            navigationController?.popViewController(animated: true)
        } else {
            validText2.text = "Please type integer value."
        }
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
