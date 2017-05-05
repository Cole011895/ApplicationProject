//
//  MobilePhoneVC.swift
//  Testing
//
//  Created by Coleman Hedges on 4/16/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class MobilePhoneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func contact(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://\(3176905477)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }

    }
    }
    @IBAction func contact_two(_ sender: Any) {
        let u:NSURL = URL(string: "TEL://3176905477")! as NSURL
        UIApplication.shared.open(u as URL, options: [:], completionHandler:nil)
        
        }
    
    override func didReceiveMemoryWarning() {
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
