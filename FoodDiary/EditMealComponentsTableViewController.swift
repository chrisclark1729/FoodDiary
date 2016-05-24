//
//  EditMealComponentsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/10/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class EditMealComponentsTableViewController: UITableViewController {
    
    @IBOutlet var dinersTableView: UITableView!
    let textCellIdentifier = "TextCell"
    var foodDiaryEntry: FoodDiaryEntry?
    var suggestedDiners = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dinersTableView.delegate = self
        dinersTableView.dataSource = self
        
        if let entry = self.foodDiaryEntry {
            let suggestedDinersFromQuery = entry.getDinerSuggestions()
            self.suggestedDiners = suggestedDinersFromQuery
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func addDiner(sender: AnyObject) {
        
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Diner", message: "", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Add", style: .Default) { action -> Void in
            
            let diner = OtherDiner(entry: self.foodDiaryEntry!, name: inputTextField!.text)
            self.foodDiaryEntry?.addDiner(diner)
            self.tableView.reloadData()
            self.foodDiaryEntry!.save()
        }
        actionSheetController.addAction(nextAction)
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
        }
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return the number of sections.
        if self.suggestedDiners.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Frequent Diners"
        } else {
            return "Other Diners"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return self.foodDiaryEntry!.diners.count
        } else if section == 1 {
            return self.suggestedDiners.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        let row = indexPath.row
        if indexPath.section == 0 {
            let diner = self.foodDiaryEntry!.diners[row]
            cell.textLabel?.text = diner.name!
            
            return cell
        } else if indexPath.section == 1 {
            let dinerNameString = self.suggestedDiners[row]
            cell.textLabel?.text = dinerNameString
            
            return cell
        } else {
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let dinerNameString = self.suggestedDiners[indexPath.row]
            self.foodDiaryEntry!.addDinerWithName(dinerNameString)
            self.suggestedDiners.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
        self.foodDiaryEntry!.diners.removeAtIndex(indexPath.row)
        self.foodDiaryEntry!.save()
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }

    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
