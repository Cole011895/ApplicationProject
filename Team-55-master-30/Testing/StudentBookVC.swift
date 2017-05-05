//
//  StudentBookVC.swift
//  Testing
//
//  Created by Coleman Hedges on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

//Used https://github.com/paypal/PayPal-iOS-SDK to write code below

import UIKit

class StudentBookVC: UIViewController,UIPickerViewDelegate, PayPalPaymentDelegate, UINavigationControllerDelegate  {
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration()
    

    
    @IBOutlet weak var availableTimes: UITextView!
    @IBOutlet weak var sub: UITextField!
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var loca: UITextField!
    var userID = user?["UID"]
    var tutorID: Int!
    var tutorLocations = [Dictionary<String, Any>()]
    var tutorClasses = [Dictionary<String, Any>()]
    var availables = [Dictionary<String, Any>]()
    var pickclas = [String]()
    var locationPicker = ["Wells", "Kelley", "Info West"]
    var price: Float!
    var times = ""
    var startDate: Date!
    var endDate: Date!
    var date: String!
    var cost: String!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBAction func start_time(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(StudentBookVC.studentstarttime(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    func studentstarttime(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        start.text = dateFormatter.string(from: sender.date)
        startDate = sender.date
        
    }
    
    
    @IBAction func end_time(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(StudentBookVC.studentEndTime), for: UIControlEvents.valueChanged)
    }
    func studentEndTime(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        end.text = dateFormatter.string(from: sender.date)
        endDate = sender.date
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for clss in tutorClasses {
            pickclas.append(clss["Category"] as! String + "\(clss["Number"]!)")
        }
        for avl in availables {
            times.append("\(avl["Start"]!) - \(avl["End"]!)\n")
        }
        self.availableTimes.text = self.times
        var clas = UIPickerView()
        var location = UIPickerView()
        location.delegate = self
        clas.delegate = self
        priceLabel.text = "$\(price!)0"
        
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Crimson Tutor"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        
        self.loca.inputView = location
        self.sub.inputView = clas
        // Do any additional setup after loading the view.
        let tool = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        location.tag = 0
        clas.tag = 1
        tool.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        tool.barStyle = UIBarStyle.default
        
        tool.tintColor = UIColor.red
        
        tool.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(StudentBookVC.donePressed(_:)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let theLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        theLabel.font = UIFont(name: "Helvetica", size: 17)
        
        theLabel.backgroundColor = UIColor.clear
        
        theLabel.textColor = UIColor(red: 220.0, green: 20.0, blue: 60.0, alpha: 1.0)
        
        theLabel.text = "Subject"
        
        theLabel.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: theLabel)
        
        tool.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        sub.inputAccessoryView = tool
        loca.inputAccessoryView = tool
        start.inputAccessoryView = tool
        end.inputAccessoryView = tool
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1{
            return pickclas.count
        }
        else if pickerView.tag == 0{
            return locationPicker.count
        }
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1{
            return pickclas[row]
        }
        else {
            return locationPicker[row]
        }
        return ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            sub.text = pickclas[row]
        }
        else{
            loca.text = locationPicker[row]
        }
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        sub.resignFirstResponder()
        loca.resignFirstResponder()
        start.resignFirstResponder()
        end.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func bookPressed(_ sender: Any) {
   
        let item1 = PayPalItem(name: "Tutoring Session", withQuantity: 1, withPrice: NSDecimalNumber(string: "\(price!)0"), withCurrency: "USD", withSku: "1")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Tutoring Session", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }

        
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
        
        let formatter = DateFormatter()
    
        formatter.dateFormat = "hh:mm:ss"
        let startTime = formatter.string(from: startDate!)
        let endTime = formatter.string(from: endDate!)
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/addAppointment.php?AvailableID=\(availables[0]["AvailableID"]!)&TutorID=\(tutorID!)&Start=\(startTime)&End=\(endTime)&ClassID=\(tutorClasses[0]["ClassID"]!)&StudentID=\(userID!)&Date=\(date!)")
        print("http://cgi.soic.indiana.edu/~team55/addAppointment.php?AvailableID=\(availables[0]["AvailableID"]!)&TutorID=\(tutorID!)&Start=\(startTime)&End=\(endTime)&ClassID=\(tutorClasses[0]["ClassID"]!)&StudentID=\(userID!)&Date=\(date!)")
        // declare request to proceed php file
        var request = URLRequest(url: url!)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
           
            }.resume()
        
    
        
        
        DispatchQueue.main.async(execute: {
            appDelegate.student_login()
        })
        
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
