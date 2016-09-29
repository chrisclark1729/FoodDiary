//
//  EditMoodTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/2/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class EditMoodTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var moodSearch: UISearchBar!
    var foodDiaryEntry: FoodDiaryEntry?
    var searchActive: Bool = false
    var selectedMood:String = ""
    var data:[PFObject]!
    var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodSearch.delegate = self
        search()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var selectedSuggestion:String?
    var moodField: UITextField?
    
    func search(_ searchText: String? = nil) {
        let searchMood = PFQuery(className: "Mood")
            searchMood.whereKey("mood", contains: searchText)
            searchMood.limit = 10
            searchMood.order(byAscending: "facebookMobileRank")
        
        searchMood.findObjectsInBackground { (results, error) -> Void in
            DispatchQueue.main.async(execute: {
                self.data = results
                self.tableView.reloadData()
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "moodCell", for: indexPath)
        let obj = self.data[(indexPath as NSIndexPath).row]
        let mood = obj["mood"] as? String
        
        cell.textLabel!.text = mood
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mood = self.data[(indexPath as NSIndexPath).row]["mood"]
        self.foodDiaryEntry?.mood = mood! as! String
        foodDiaryEntry!.save()
        self.navigationController?.popViewController(animated: true)
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
