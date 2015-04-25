//
//  HighScoreViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/24/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class HighScoreViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    private var rows = ["Win %","Games Completed", "Games Won", "Games Lost", "Games Tied","Games Aborted", "Total Playtime", "Goals Scored", "Goals Allowed"]
    
    
    
    
    private var currentIndex = 0
    
    private var users : [User] = Users.getAllUsers()
    override func viewDidLoad() {
        Util.applyBackgroundToView(self.view)
        self.navigationController!.navigationBar.hidden = false

        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate
        
        pickerView.backgroundColor = UIColor.whiteColor()
    }
    
    
    //TODO: Do the sorting correctly
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (currentIndex != row) {
            currentIndex = row
            users.sorted {$0.0.getSortValueForIndex(self.currentIndex)! > $1.getSortValueForIndex(self.currentIndex)!}
            tableView.reloadData()

        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return rows[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            var row = indexPath.row
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("UserRow")! as! UITableViewCell
            cell.textLabel!.text = users[row].getUsername()!
            let x : Float = users[row].getSortValueForIndex(currentIndex)!
            var string = ""
            if currentIndex==0 {
                string = x.description
            } else if currentIndex == 6 {
                string = Util.getTimeString(Int(x))
            } else {
                string = String(Int(x))
            }
            
            cell.detailTextLabel!.text = string
            
            return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowUserDetailSegue") {
            SoundManager().playButtonPressedSound()

            let row=tableView.indexPathForSelectedRow()!.row
            let vc = segue.destinationViewController as!UserProfileViewController
            
            vc.user = users[row]
        }
    }
   
}