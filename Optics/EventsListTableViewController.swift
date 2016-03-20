//
//  EventsTableViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 18/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class EventsListTableViewController: UITableViewController {

    var events:[JSON] = []
    let ModelEvent    = Event()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        ModelEvent.getAll( {
            data in
            dispatch {
                self._setAndReloadData( data )
            }
        } ) {
            dispatch {
                self.error( "Une erreur", message: "Une erreur", buttonText: "Ok" )
            }
        }
    }
    
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func _setAndReloadData(data: NSData)
    {
        let events = JSON( data: data )
        
        self.events = events[ "data" ].arrayValue
        self.tableView.reloadData()
    }

    private func _addAndReloadData(data: NSData) {
        let events = JSON( data: data )
        
        self.events.append( events["data"] )
        self.tableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "eventCell", forIndexPath: indexPath ) as! EventTableViewCell

        let event = events[ indexPath.row ]
        let date = Date.convertDateFormater( event["created_at"].string! )
        
        tableView.separatorColor = UIHelper.red
        
        cell.eventTitle.text = event["title"].string
        cell.eventDate.text = date
        //cell.picturesCount.text = String(folder["pictures"]!)
        cell.usersCount.text = String( event["users_count"] )

        return cell
    }
    
    @IBAction func menuBtnTapped(sender: AnyObject)
    {
        
    }
    
    @IBAction func addEventBtnTapped(sender: AnyObject)
    {
        
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "eventDetailSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailViewController = segue.destinationViewController as! EventDetailsTableViewController
            
            detailViewController.currentEvent = events[ indexPath.row ]
        }

    }

}
