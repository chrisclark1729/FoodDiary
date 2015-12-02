//
//  EditMoodTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/2/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class EditMoodTableViewController: UITableViewController {

    var foodDiaryEntry: FoodDiaryEntry?
    
    // TODO: Query
    //var locationNameSuggestions:[foodDiaryEnry] = ["suggestion1", "suggestion2", "suggestion3"]
    var moodSuggestions:[String] = ["mood1", "mood2", "angry"]
    var selectedSuggestion:String?
    var moodField: UITextField?
    
    @IBAction func updateMood(sender: UIButton) {
        self.foodDiaryEntry?.mood = self.moodField!.text!
        foodDiaryEntry!.save()
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.initMoodField()
    }
    
    
    func initMoodField() {
        if let editMoodField = self.moodField {
            editMoodField.becomeFirstResponder()
            
            if let entry = foodDiaryEntry {
                
                editMoodField.text = entry.mood
            }
            else {
                print("No Food Entry")
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return moodSuggestions.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("moodCell", forIndexPath: indexPath) as! MoodFieldTableViewCell
            cell.moodField.text = self.selectedSuggestion
            self.moodField = cell.moodField
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("moodSuggestionCell", forIndexPath: indexPath)
            cell.textLabel!.text = self.moodSuggestions[indexPath.row]
            return cell
        }
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
