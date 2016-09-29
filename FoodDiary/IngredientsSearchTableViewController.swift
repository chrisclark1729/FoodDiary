//
//  IngredientsSearchTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/17/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class IngredientsSearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchIngredients: UISearchBar!
    var foodDiaryEntry: FoodDiaryEntry?
    var searchActive: Bool = false
    var data:[PFObject]!
    var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchIngredients.delegate = self
        search()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(_ searchText: String? = nil){
        let query = PFQuery(className: "Ingredients")
            query.whereKey("ingredientName", contains: searchText)
            query.limit = 100
            query.order(byDescending: "ingredientName")
        
        query.findObjectsInBackground { (results, error) -> Void in
            DispatchQueue.main.async(execute: {
                self.data = results
                self.tableView.reloadData()
            })

        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        let obj = self.data[(indexPath as NSIndexPath).row]
        
        
        let ingredientName = obj["ingredientName"] as? String
        let unitOfMeasurement = obj["unitOfMeasurement"] as? String

        cell.textLabel!.text = ingredientName! + " (" + unitOfMeasurement! + ")"

        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addIngredientDetail"
            
        {
            
            let destination = segue.destination as! IngredientAddTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            let selectedIndexPath = self.tableView.indexPathForSelectedRow
            let obj = self.data[(selectedIndexPath! as NSIndexPath).row]
            destination.ingredient = obj
            Session.sharedInstance.currentIngredient = obj
            
            
        }
        
    }

}
