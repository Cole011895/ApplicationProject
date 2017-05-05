//
//  TutorViewVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorViewVC: UIViewController {
    var tutorID: Int!
    var tutorInfo = Dictionary<String, Any>()
    var tutorLocations = [Dictionary<String, Any>()]
    var tutorClasses = [Dictionary<String, Any>()]
    var tutorRatings = [Dictionary<String, Any>()]
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var classLabel: UITextView!
    @IBOutlet weak var locationLabel: UITextView!
    @IBOutlet weak var reviewLabel: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call func of laoding posts
        loadProfile()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTutorSchedule" {
            if user == nil {
                
                let slogin = self.storyboard?.instantiateViewController(withIdentifier: "StudentLoginVC") as! StudentLoginVC
                self.present(slogin, animated: true, completion: nil)
            }
            if let selectVC = segue.destination as? StudentScheduleCalendarVC {
                selectVC.tutorID = self.tutorID
                selectVC.tutorClasses = self.tutorClasses
                selectVC.price = self.tutorInfo["Rate"] as! Float?
            }
        }
        
    }
    
    // func of loading posts from server
    func loadProfile() {
        
        // shortcut to id
        let id = tutorID
        
        // accessing php file via url path
        let url = URL(string: "http://cgi.soic.indiana.edu/~team55/tutorDetails.php?id=\(id!)")!
        
        // declare request to proceed php file
        var request = URLRequest(url: url)
        
        // declare method of passing information to php file
        request.httpMethod = "POST"
        
        // pass information to php file
        //let body = "id=\(id)"
        //request.httpBody = body.data(using: String.Encoding.utf8)
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {
                
                // no error of accessing php file
                if error == nil {
                    
                    do {
                        
                        // getting content of $returnArray variable of php file
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? Dictionary<String, [Dictionary<String, Any>]>
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        //load tutor classes
                        self.tutorClasses = parseJSON["Classes"]!
                        if self.tutorClasses[0]["Title"] as? String != "none"{
                        var classes = ""
                        var classCount = 0
                        for c in self.tutorClasses {
                            let course = "\(c["Category"]!)" + "\(c["Number"]!)"
                            if classCount == 0{
                                classes.append("• \(course)")
                                classCount = 1
                            } else {
                                classes.append("\n• \(course)")
                            }
                        }
                        self.classLabel.text = classes
                        } else {
                                self.classLabel.text = "Tutor has selected no classes"
                            }
                        
                        //load tutor locations
                        /*self.tutorLocations = parseJSON["Locations"]!
                        if self.tutorLocations[0]["Name"] as? String != "none" {
                        var locations = ""
                        var locationCount = 0
                        for l in self.tutorLocations {
                            let location = "\(l["Name"]!)"
                            if locationCount == 0{
                                locations.append("• \(location)")
                                locationCount = 1
                            } else {
                                locations.append("\n• \(location)")
                            }
                        }
                        self.locationLabel.text = locations
                        } else {
                            self.locationLabel.text = "Tutor has selected no locations"
                        }*/
                        
                        //load tutor reviews
                        self.tutorRatings = parseJSON["Ratings"]!
                        if self.tutorRatings[0]["RatingText"] as? String != "none"{
                        var ratings = ""
                        var ratingCount = 0
                        for r in self.tutorRatings {
                            let rating = "\(r["RatingText"]!)"
                            if ratingCount == 0{
                                ratings.append("• \(rating)")
                                ratingCount = 1
                            } else {
                                ratings.append("\n• \(rating)")
                            }
                        }
                        self.reviewLabel.text = ratings
                        } else {
                            self.reviewLabel.text = "No Ratings yet"
                        }
                        
                        //load tutor information
                        self.tutorInfo = (parseJSON["Info"]?[0])!
                        self.nameLabel.text = self.tutorInfo["Fullname"] as! String?
                        self.aboutText.text = self.tutorInfo["Bio"] as! String?
                        self.majorLabel.text = self.tutorInfo["Major"] as! String?
                        let price = self.tutorInfo["Rate"] as! Float?
                        if price == 0 {
                            self.priceLabel.text = "Free!"
                        } else {
                            self.priceLabel.text = "$\(price!)0"
                        }
                        
                        let rating = self.tutorInfo["Rating"] as! Float?
                 
                        
                        self.cosmosView.rating=Double(rating!)
                        self.cosmosView.updateOnTouch = false
                        
                        self.yearLabel.text = self.tutorInfo["Year"] as! String?
                        
                        let ava = self.tutorInfo["Ava"] as! String?
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
                                        self.profilePic.image = UIImage(data: imageData!)
                                    })
                                }
                            })
                            
                        }else{
                            self.profilePic.image = #imageLiteral(resourceName: "ava.png")
                        }
                        
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

}
