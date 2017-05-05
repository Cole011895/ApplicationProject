//
//  AvailableVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 2/18/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class AvailableVC: UITableViewController, UISearchBarDelegate {
    
  
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var tutors = [Dictionary<String, Any>]()
    var initialTutors = [Dictionary<String, Any>]()
    var filteredTutors = [Dictionary<String, Any>]()
    var inSearchMode = false
    var searchCriteria = "Fullname"
    
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
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["Name", "Class"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredTutors.count
        }else {
            return tutors.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AvailableTVC
        
        //get a tutor and all of his/her information into the cell
        
        var tutor = Dictionary<String,Any>()
        
        if inSearchMode {
            tutor = filteredTutors[indexPath.row]
        } else {
            tutor = tutors[indexPath.row]
        }
        
        let name = tutor["Fullname"] as? String
        let rate = tutor["Rate"] as? Float
        let classes = tutor["Classes"] as? String
        let tutorID = tutor["UID"] as? Int
        let ava = tutor["Ava"] as? String
        let rating = tutor["Rating"] as? Float
        
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
                    })
                }
            })
            
        }else{
            cell.photo.image = #imageLiteral(resourceName: "ava.png")
        }
        
        if rate == 0 {
            cell.rate.text = "Free"
        } else {
            cell.rate.text = "$\(rate!)0"
        }
        
        
        cell.cosmosView.starMargin = 1
        cell.cosmosView.updateOnTouch = false
        cell.cosmosView.rating = Double(rating!)
        cell.name.text = name
        cell.clas_s.text = classes
        cell.tutorID = tutorID
        
        return cell
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if searchBar.selectedScopeButtonIndex == 0 {
            self.searchCriteria = "Fullname"
        }
        else if searchBar.selectedScopeButtonIndex == 1 {
            self.searchCriteria = "Classes"
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            tableview.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            //let lower = searchBar.text!.lowercased()
            
            print(tutors)
            
           filteredTutors = []
            
            for t in tutors {
                let tutorSearch = t[self.searchCriteria] as! String
                if tutorSearch.contains(searchBar.text!){
                    filteredTutors.append(t)}
            }
        
            tableview.reloadData()
        }
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
        if segue.identifier == "availableSegue" {
            if let detailsVC = segue.destination as? TutorViewVC {
                if let tutor = sender as? AvailableTVC {
                    detailsVC.tutorID = tutor.tutorID
                }
            }
        }
        
    }

    

}
