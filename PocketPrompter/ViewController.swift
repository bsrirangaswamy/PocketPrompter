//
//  ViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 8/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : - IBOutlets
    @IBOutlet weak var userDataTableView: UITableView!
    
    var userDataArray: [NSManagedObject] = []
    var currentSelectedIndex = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userDataTableView!.register(UINib(nibName: "PromptDataTableViewCell", bundle: nil), forCellReuseIdentifier: "promptDataTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchStoredData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentSelectedIndex = -1
    }
    
    // MARK :- TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptDataTableViewCell") as! PromptDataTableViewCell
        
        if let data = userDataArray[indexPath.row].value(forKeyPath: SavedUserData.title.rawValue) {
            print ("Bala saved User Data in table view = \(data)")
            cell.textTitleLabel.text = data as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath.row
        self.performSegue(withIdentifier: "imageRecognizer", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.deleteExistingStoredData(index: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Guard to check if the action is performed by a table view selection or new file selection
        guard currentSelectedIndex != -1 else { return }

        // Guard to ensure current index is within the bounds of the array
        guard userDataArray.count > currentSelectedIndex else { return }
        
        switch segue.identifier {
        case .some(let seg) where seg.contains("imageRecognizer"):
            let navController = segue.destination as! UINavigationController
            
            let dest = navController.topViewController as! ImageRecognizerViewController
            
            dest.objectIndex = currentSelectedIndex
            
            if let data = userDataArray[currentSelectedIndex].value(forKeyPath: SavedUserData.title.rawValue) {
                dest.savedTitle = data as? String
            }
            
            if let bodyData = userDataArray[currentSelectedIndex].value(forKeyPath: SavedUserData.bodyText.rawValue) {
                dest.savedBodyText = bodyData as? String
            }
        default:
            break
        }
    }
    
    func fetchStoredData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserFile")
        
        do {
            userDataArray = try managedContext.fetch(fetchRequest)
            print ("Bala fetched data success")
            UIView.transition(with: self.userDataTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {self.userDataTableView.reloadData()}, completion: nil)
//            userDataTableView.reloadData()
        } catch let error as NSError {
            print("Bala Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteExistingStoredData(index: Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserFile")
        
        do {
            userDataArray = try managedContext.fetch(fetchRequest)
            if  userDataArray.count > index {
                print ("Bala deletaExistingStoredData success")
                
                let storedFile = userDataArray[index]
                managedContext.delete(storedFile)
                
                do {
                    try managedContext.save()
                    
                    // refetch stored data and update the local userDataArray
                    self.fetchStoredData()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Bala Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

