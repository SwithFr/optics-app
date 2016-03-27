//
//  EventsTableViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 18/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class EventsListTableViewController: UITableViewController {

    @IBOutlet var eventIdField: UITextField?
    var events:[JSON] = []
    let ModelEvent    = Event()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.toolbar.barTintColor = UIHelper.black
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
    
    /*
        LIIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    /*
        TABLE CONTROLS
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier( "eventCell", forIndexPath: indexPath ) as! EventTableViewCell
        let event = events[ indexPath.row ]
        let date  = Date.convertDateFormater( event["created_at"].string! )
        
        tableView.separatorColor = UIHelper.red
        
        cell.eventTitle.text = event["title"].string!
        cell.eventDate.text = date
        //cell.picturesCount.text = String(folder["pictures"]!)
        cell.usersCount.text = String( event["users_count"] )
        
        return cell
    }
    
    /*
        ACTIONS
    */
    // Add or Join event
    @IBAction func addEventBtnTapped(sender: AnyObject)
    {
        let popView = UIAlertController(
            title: "Ajouter un évènement",
            message: "Voulez vous créer un évènement ou en rejoindre un éxistant ?",
            preferredStyle: .Alert
        )
        
        let defaultAction = UIAlertAction( title: "Créer", style: .Default) {
            ( alert: UIAlertAction! ) in
            self._displayAddScreen()
        }
        
        let otherAction = UIAlertAction( title: "Rejoindre", style: .Default) {
            ( alert: UIAlertAction! ) in
            self._displayJoinScreen()
        }
        
        let cancelAction = UIAlertAction( title: "Annuler", style: .Destructive, handler: nil )
        
        popView.addAction(defaultAction)
        popView.addAction(otherAction)
        popView.addAction(cancelAction)
        
        self.presentViewController( popView, animated: true, completion: nil )

    }
    
    /*
        PRIVATE
    */
    // setData
    private func _setAndReloadData(data: NSData)
    {
        let events = JSON( data: data )
        
        self.events = events[ "data" ].arrayValue
        self.tableView.reloadData()
    }
    
    // addEvent
    private func _addAndReloadData(data: NSData) {
        let events = JSON( data: data )
        
        self.events.insert( events["data"], atIndex: 0 )
        self.tableView.reloadData()
    }
    
    // Show the add event screen
    private func _displayAddScreen() {
        let addEventVC = self.storyboard?.instantiateViewControllerWithIdentifier( "addEventView" )
        self.navigationController?.pushViewController( addEventVC!, animated: true )
    }
    
    // Add input in UIAlertView
    private func _addTextField( textField: UITextField! ){
        textField.placeholder = "85171249"
        self.eventIdField = textField
    }
    
    // Show the event join alert
    private func _displayJoinScreen() {
        
        let popView = UIAlertController( title: "Rejoindre un évènement", message: "Saisissez le code de l'évènement", preferredStyle: .Alert )
        
        let defaultAction = UIAlertAction( title: "Rejoindre", style: .Default) {
            ( alert: UIAlertAction! ) in
            let iEventID:NSString = ( self.eventIdField?.text )!
            
            self.ModelEvent.join( iEventID as String ) {
                data in
                dispatch {
                    self._addAndReloadData( data )
                }
            }
        }
        let cancelAction = UIAlertAction( title: "Annuler", style: .Destructive, handler: nil )
        
        popView.addTextFieldWithConfigurationHandler(_addTextField)
        popView.addAction(defaultAction)
        popView.addAction(cancelAction)
        
        self.presentViewController( popView, animated: true, completion: nil )
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "eventDetailsSegue" ) {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailViewController = segue.destinationViewController as! EventDetailsTableViewController
            
            detailViewController.currentEvent = events[ indexPath.row ]
        }

    }

}
