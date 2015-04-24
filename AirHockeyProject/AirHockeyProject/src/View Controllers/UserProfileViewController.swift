//
//  UserProfileViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/24/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController :  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var user : User!
    private var rows = ["Games Completed", "Games Won", "Games Lost", "Games Tied","Games Aborted", "Total Playtime", "Goals Scored", "Goals Allowed"]
    private var statsList : [String] = []
    
    override func viewDidLoad() {
        Util.applyBackgroundToView(self.view)
        tableView.layer.borderColor = UIColor.redColor().CGColor
        tableView.layer.borderWidth = 2
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate
        self.navigationController!.navigationBar.hidden = false
        


    }
    
    override func viewWillAppear(animated: Bool) {
        usernameLabel.text = user.getUsername()!
        let stats = user.getStats()!
        statsList.append(String(stats.getGamesComplete()!))
        statsList.append(String(stats.getGamesWon()!))
        statsList.append(String(stats.getGamesLost()!))

        statsList.append(String(stats.getGamesTied()!))
        statsList.append(String(stats.getGamesExited()!))
        
        statsList.append(String(stats.getTimePlayed()!)) // TODO: Fix this one

        statsList.append(String(stats.getGoalsScored()!))
        statsList.append(String(stats.getGoalsAgainst()!))
        

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StatRow")! as! UITableViewCell
        cell.textLabel!.text = rows[row]
        cell.detailTextLabel!.text = statsList[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(rows.count)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(rows.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    
}