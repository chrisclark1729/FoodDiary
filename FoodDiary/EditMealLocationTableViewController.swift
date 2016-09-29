//
//  EditMealLocationTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/23/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class EditMealLocationTableViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?
    var locationNameSuggestions:[String] = []
    var selectedSuggestion:String?
    var locationNameField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initLocationNameField()
        self.locationNameSuggestions = FoodDiaryEntry.getLocationSuggestions(self.foodDiaryEntry!.location)
        self.tableView.reloadData()
        
    }
    
    @IBAction func updateLocationName(_ sender: UIButton) {
        self.foodDiaryEntry?.locationName = self.locationNameField!.text!
        foodDiaryEntry!.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func initLocationNameField() {
        self.locationNameField!.text = self.foodDiaryEntry?.locationName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            print("location Name Suggesions are counting: \(locationNameSuggestions.count)")
           return locationNameSuggestions.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameCell", for: indexPath) as! LocationNameFieldTableViewCell
            if let suggestion = self.selectedSuggestion {
                cell.locationNameField.text = suggestion
            } else {
                cell.locationNameField.text = foodDiaryEntry?.locationName
            }
            
            self.locationNameField = cell.locationNameField
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameSuggestionCell", for: indexPath)
            cell.textLabel!.text = self.locationNameSuggestions[(indexPath as NSIndexPath).row]
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationName = self.locationNameSuggestions[(indexPath as NSIndexPath).row]
        
        self.selectedSuggestion = locationName
        self.tableView.reloadData()
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
