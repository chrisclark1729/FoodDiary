//
//  ViewAndEditMealIngredientsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 10/13/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit

class ViewAndEditMealIngredientsTableViewController: UITableViewController {
    

    @IBOutlet var ingredientList: UITableView!
    
    let textCellIdentifier = "IngredientCell"
    
    var foodDiaryEntry: FoodDiaryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.foodDiaryEntry!.ingredientDetails.count

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)

        let row = indexPath.row
        let ingredientDetail = self.foodDiaryEntry!.ingredientDetails[row]
        let ingredientId = ingredientDetail.ingredientId
        ingredientId?.fetch()
        let ingredientName = ingredientId!["ingredientName"] as? String
        let ingredientUnitOfMeasurement = ingredientId!["unitOfMeasurement"] as? String
        let calories = ingredientId!["calories"] as? Float
        let totalCalories = calories! * ingredientDetail.quantity!
        var unitOfMeasurementSeparator = ") "
        
        if ingredientDetail.quantity! == 1 {
            unitOfMeasurementSeparator = "s) "
        }

        cell.textLabel?.text = ingredientName! + " (" + (NSString(format: "%.1f",ingredientDetail.quantity!) as String) + " " + ingredientUnitOfMeasurement! + unitOfMeasurementSeparator + (NSString(format: "%.0f",totalCalories) as String) + " cal."
        
        return cell
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
