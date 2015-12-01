//
//  EditMealTagsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/26/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class EditMealTagsTableViewController: UITableViewController {
    
    @IBOutlet var notesTableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    var foodDiaryEntry: FoodDiaryEntry?
  //  var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
    //    self.notes = self.foodDiaryEntry!.notes

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @IBAction func addNote(sender: AnyObject) {
        //TODO: Make this unique class
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Tag/Note", message: "", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Add", style: .Default) { action -> Void in
            
            let note = Note(entry: self.foodDiaryEntry!, note: inputTextField!.text)
            self.foodDiaryEntry?.addNote(note)
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.foodDiaryEntry!.notes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) 

        let row = indexPath.row
        let note = self.foodDiaryEntry!.notes[row]
        cell.textLabel?.text = note.note!

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            self.foodDiaryEntry!.notes.removeAtIndex(indexPath.row)
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
