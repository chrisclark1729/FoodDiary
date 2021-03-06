//
//  EditSummaryDatesTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/4/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class EditSummaryDatesTableViewController: UITableViewController {
    
    var dayFormatter = DateFormatter()
    @IBOutlet weak var editSummaryStartDatePicker: UIDatePicker!
    @IBOutlet weak var editSummaryEndDatePicker: UIDatePicker!

    @IBAction func updateNutritionSummaryData(_ sender: UIButton) {
        
        Session.sharedInstance.currentSelectedStartDate = editSummaryStartDatePicker.date
        Session.sharedInstance.currentSelectedEndDate = editSummaryEndDatePicker.date
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editSummaryStartDatePicker.date = Session.sharedInstance.currentSelectedStartDate! as Date
        self.editSummaryEndDatePicker.date = Session.sharedInstance.currentSelectedEndDate! as Date
        
        //User can only review at most one quarter at a time (92 days is length of Q3 & Q4)
        self.editSummaryStartDatePicker.minimumDate = Session.sharedInstance.currentSelectedEndDate?.addingTimeInterval(-92*24*60*60) as Date?

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
