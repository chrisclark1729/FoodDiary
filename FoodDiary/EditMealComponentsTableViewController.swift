//
//  EditMealComponentsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/10/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class EditMealComponentsTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var dinersTableView: UITableView!

    let textCellIdentifier = "TextCell"
    
    var foodDiaryEntry: FoodDiaryEntry?
    var otherDiners = [OtherDiner]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dinersTableView.delegate = self
        dinersTableView.dataSource = self

        
        
        var getOtherDiners:PFQuery = PFQuery(className:"FoodDiaryEntryDiners")
        
        getOtherDiners.whereKey("foodDiaryEntryId", equalTo: foodDiaryEntry!.toPFObject!)
        getOtherDiners.limit = 30 // Limit query results just in case
        getOtherDiners.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) diners.")
                
                           } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
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
            
            var diner = OtherDiner(entry: self.foodDiaryEntry!, name: inputTextField!.text)
            self.foodDiaryEntry?.addDiner(diner)
            self.tableView.reloadData()
            println(self.foodDiaryEntry?.mealID)
            self.foodDiaryEntry!.save()
        }
        actionSheetController.addAction(nextAction)
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
        }
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
 
    @IBAction func addNote(sender: AnyObject) {
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Tag/Note", message: "", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Add", style: .Default) { action -> Void in
            
            var note = Note(entry: self.foodDiaryEntry!, note: inputTextField!.text)
            self.foodDiaryEntry?.addNote(note)
            self.tableView.reloadData()
            println(self.foodDiaryEntry?.mealID)
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
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
       // return self.otherDiners.count
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = "Chris Clark"
        
        /*
        let otherDiner = self.otherDiners[indexPath.row]
        println("is this thing on?")
        
        
        if let name = otherDiner.name {
            cell.textLabel?.text = "Chris"
            //cell.textLabel?.text = name
            
        } else {
            cell.textLabel?.text = "No Name"
        } */
        
        return cell
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
