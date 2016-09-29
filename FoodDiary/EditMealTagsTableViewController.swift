//
//  EditMealTagsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/26/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class EditMealTagsTableViewController: UITableViewController {
    
    @IBOutlet var notesTableView: UITableView!
    let textCellIdentifier = "TextCell"
    var foodDiaryEntry: FoodDiaryEntry?
    var suggestedTags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        if let entry = self.foodDiaryEntry {
            let suggestedTagsFromQuery = entry.getTagSuggestions()
            self.suggestedTags = suggestedTagsFromQuery
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func addNote(_ sender: AnyObject) {
        //TODO: Make this unique class
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Tag/Note", message: "", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) { action -> Void in
            
            let note = Note(entry: self.foodDiaryEntry!, note: inputTextField!.text)
            self.foodDiaryEntry?.addNote(note)
            self.tableView.reloadData()
            self.foodDiaryEntry!.save()
        }
        actionSheetController.addAction(nextAction)
        actionSheetController.addTextField { textField -> Void in
            inputTextField = textField
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        // Return the number of sections.
        if self.suggestedTags.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Frequently Used Notes"
        } else {
            return "Notes"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return self.foodDiaryEntry!.notes.count
        } else if section == 1 {
            return self.suggestedTags.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = (indexPath as NSIndexPath).row
        if (indexPath as NSIndexPath).section == 0 {
            let note = self.foodDiaryEntry!.notes[row]
            cell.textLabel?.text = note.note!
            
            return cell
        } else if (indexPath as NSIndexPath).section == 1 {
            let tagString = self.suggestedTags[row]
            cell.textLabel?.text = tagString
            
            return cell
        } else {
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            let tagString = self.suggestedTags[(indexPath as NSIndexPath).row]
            self.foodDiaryEntry!.addNoteWithName(tagString)
            self.suggestedTags.remove(at: (indexPath as NSIndexPath).row)
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            self.foodDiaryEntry!.notes.remove(at: (indexPath as NSIndexPath).row)
            self.foodDiaryEntry!.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
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
