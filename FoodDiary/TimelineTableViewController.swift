//
//  TimelineTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController, UIAlertViewDelegate {
    
    
    var dataManager = DataManager()
    var dateFormatter = DateFormatter()
    var dayFormatter = DateFormatter()
    var timeFormatter = DateFormatter()
    var meals:[FoodDiaryEntry]?
    var rowToDelete: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataManager.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor( red: 114/255, green: 180/255, blue:201/255, alpha: 1.0 )
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Tofino-Book", size: 15)!]
       //  navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
     //   navigationController?.navigationBar.tintColor = UIColor.white
        if PFUser.current() != nil {
          self.dataManager.loadTimelineData()
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "MMM dd, yyyy"
        timeFormatter.dateFormat = "h:mm a"
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineTableViewController.userDidLogIn(_:)), name: NSNotification.Name(rawValue: "userDidLogIn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineTableViewController.archiveMeal(_:)), name: NSNotification.Name(rawValue: "archiveMealNotification"), object: nil)
        
    }
    
    func userDidLogIn(_ notification: Notification) {
        self.dataManager.loadTimelineData()
    }
    
    func archiveMeal(_ notification: Notification) {
        let mealToArchive: FoodDiaryEntry = notification.object as! FoodDiaryEntry
        var indexToArchive: Int?
        for (index, element) in meals!.enumerated() {
            print("Item \(index): \(element)")
            if element == mealToArchive {
                indexToArchive = index
                break
            }
                    }
        self.meals!.remove(at: indexToArchive!)
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func deleteFoodDiaryEntry(_ button: UIButton) {
        let alert: UIAlertView = UIAlertView()
        
            if let superview = button.superview {
                if let cell = superview.superview as? TimelineTableViewCell {
                    let indexPath = self.tableView.indexPath(for: cell)
                    self.rowToDelete = indexPath
                }
        }
        
        alert.title = "Delete"
        alert.message = "Are you sure you want to delete this entry?"
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.delegate = self  // set the delegate here
        alert.show()
    
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitle(at: buttonIndex)
        print("\(buttonTitle!) pressed")
        if buttonTitle == "Yes" {
            // TODO: Figure out how I know what the current food Diary Entry Id is?
            let entry = self.meals![(self.rowToDelete! as NSIndexPath).row]
            entry.deleteFromBackEnd()
            self.meals!.remove(at: (self.rowToDelete! as NSIndexPath).row)
            tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let meals = self.meals {
            return meals.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineTableViewCell
        
        let meal = meals![(indexPath as NSIndexPath).row]
        
        var mealImageFile:PFFile?
        mealImageFile = meal.imgURL as? PFFile
        
        if mealImageFile != nil {
            mealImageFile!.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.mealImage.image = image
                    }
                }
            }
        } else {
            print("mealImageFile is nil.")
        }
        
        let calories = NSString(format: "%.0f", meal.calories)
        
        cell.mealName.text = meal.mealName
        cell.mealLocationName.text = meal.locationName
        cell.mealDate.text = dayFormatter.string(from: meal.timestamp as Date)
        cell.mealTime.text = timeFormatter.string(from: meal.timestamp as Date)
        cell.calorieLabel.text = calories as String
        
        cell.contentView.layer.borderWidth = 13.5
        cell.contentView.layer.borderColor = UIColor( red: 114/255, green: 180/255, blue:201/255, alpha: 1.0 ).cgColor
        cell.contentView.layer.masksToBounds  = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            let destination = segue.destination as! ViewMealDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let meal = meals![(selectedIndexPath! as NSIndexPath).row]
            
            destination.foodDiaryEntry = meal
            
        }
        
    }
    
    func hideAllArchived() {
        if let meals = self.meals {
            var archived = [FoodDiaryEntry]()
            
            for meal in meals {
                if !meal.isVisible {
                    archived.append(meal)
                }
            }
        }
    }
    
}
