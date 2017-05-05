//
//  AppDelegate.swift
//  Testing
//
//  Created by Coleman Hedges on 1/7/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit



// global variable refered to appDelegate to be able to call it from any class / file.swift
let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate



// colors
let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)
let colorSmoothGray = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
let colorBrandBlue = UIColor(red: 45 / 255, green: 213 / 255, blue: 255 / 255, alpha: 1)



// stores all information about current user
var user : NSDictionary?


//rating page pops up when rated = false
var rated : Bool?

var apps : NSDictionary?


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appointments = [Dictionary<String, Any>]()

    
    var window: UIWindow?
    
    // boolean to check is erroView is currently showing or not
    var infoViewIsShowing = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // load content in user var
        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary

         // if user is once logged in / register, keep him logged in
         if user != nil {
         
            let id = user!["UID"] as? String
            if id != nil {
                student_login()
         }
         
        }
        
        
        apps = UserDefaults.standard.value(forKey: "parseJSON2") as? NSDictionary
        
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                                PayPalEnvironmentSandbox: "YOUR_CLIENT_ID_FOR_SANDBOX"])
        
        
        
        return true
    }
    
    
    
    
    // infoView view on top
    func infoView(message:String, color:UIColor) {
        
        // if infoView is not showing ...
        if infoViewIsShowing == false {
            
            // cast as infoView is currently showing
            infoViewIsShowing = true
            
            
            // infoView - red background
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
            
            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            
            // infoView - label to show info text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: 12)
            infoLabel.textColor = .white
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            
            // animate info view
            UIView.animate(withDuration: 0.2, animations: {
                
                // move down infoView
                infoView.frame.origin.y = 0
                
                // if animation did finish
            }, completion: { (finished:Bool) in
                
                // if it is true
                if finished {
                    
                    UIView.animate(withDuration: 0.1, delay: 3, options: .curveLinear, animations: {
                        
                        // move up infoView
                        infoView.frame.origin.y = infoView_Y
                        
                        // if finished all animations
                    }, completion: { (finished:Bool) in
                        
                        if finished {
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }
    
    
    
    
    // func to pass to home page ro to tabBar
    func login() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let taBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = taBar
        
    }
    
    func register() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let success = storyboard.instantiateViewController(withIdentifier: "TutorRegSuccessVC")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = success
        
    }
    
    //register tutor page
    func register_tutor() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let regTutor = storyboard.instantiateViewController(withIdentifier: "RegTutor")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = regTutor
        
    }
    
    //after a student logs in it goes ot tabBar2 page
    func student_login() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let tabBar2 = storyboard.instantiateViewController(withIdentifier: "tabBar2")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = tabBar2
        
    }
    

    
    func student_register() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let successStudent = storyboard.instantiateViewController(withIdentifier: "StudentSuccReg")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = successStudent
        
    }
    
    //actual student login page
    func sLogin() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabBar var
        let studentLogin = storyboard.instantiateViewController(withIdentifier: "StudentLoginVC")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = studentLogin
        
    }
    
    
    //rating a tutor after a session
    func rate() {
        
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        

        let rateTutor = storyboard.instantiateViewController(withIdentifier: "RateTutor")
        

        window?.rootViewController = rateTutor
        
    }
    
    func loadAppts(){
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/pullAppts.php")!
        
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
                        
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        
                        //UserDefaults.standard.set(parseJSON2, forKey: "parseJSON2")
                        //apps = UserDefaults.standard.value(forKey: "parseJSON2") as? NSDictionary
                        //self.appointments = parseJSON as [Dictionary<String, Any>]
                        appDelegate.appointments = parseJSON as [Dictionary<String, Any>]
                        //print(self.appointments)
                        //print(apps)
                        //print(appDelegate.appointments)
                        
                        
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
    
    

    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

