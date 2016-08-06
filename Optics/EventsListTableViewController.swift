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
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Rafraîchir")
        refreshControl!.addTarget(self, action: #selector(EventsListTableViewController.viewWillAppear), forControlEvents: UIControlEvents.ValueChanged)
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
                self.error( "Une erreur", message: "Une erreur", buttonText: "Ok", completion: nil )
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
        return events.count == 0 ? 1 : events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier( "eventCell", forIndexPath: indexPath ) as! EventTableViewCell
        
        tableView.separatorColor = UIHelper.red
        
        if ( events.count <= 0 ) {
            cell.eventTitle.text = "Aucun evenement"
            cell.eventDate.text = ""
            cell.picturesCount.text = "0"
            cell.usersCount.text = "0"
        } else {
            let event = events[ indexPath.row ]
            let date  = Date.convertDateFormater( event["created_at"].string! )
            
            cell.eventTitle.text = event["title"].string!
            cell.eventDate.text = date
            cell.picturesCount.text = String( event[ "pictures_count" ] )
            cell.usersCount.text = String( event["users_count"] )
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        if ( events.count <= 0 ) {
            return []
        } else {
            let event   = events[ indexPath.row ]
            let eventID = event[ "uuid" ].stringValue
            
            let shareAction = UITableViewRowAction( style: .Normal, title: "Partager" ) {
                _, _ in
                let shareVC = UIActivityViewController( activityItems: [ eventID ], applicationActivities: nil )
                self.presentViewController( shareVC, animated: true, completion: nil )
            }
            
            shareAction.backgroundColor = UIHelper.green
            
            if ( User.isOwner( event[ "user_id" ] ) ) {
                let deleteAction = UITableViewRowAction( style: .Normal, title: "Supprimer" ) {
                    _,_ in
                    self.askBeforeDelete( "Supprimer ?", message: "Voulez-vous vraiment supprimer cet évènemtn ?", buttonText: "Oui", otherButtonTitle: "Oula ! non !", completion: {
                        self.ModelEvent.delete( eventID ) {
                            dispatch {
                                self.events.removeObject( event )
                                self.tableView.reloadData()
                            }
                        }
                    } ) {
                        tableView.setEditing( false, animated: true )
                    }
                }
                
                deleteAction.backgroundColor = UIHelper.red
                
                return [ shareAction, deleteAction ]
            }
            
            return [ shareAction ]
        }

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
        
        self.present( popView )
    }
    
    /*
        PRIVATE
    */
    // setData
    private func _setAndReloadData(data: NSData)
    {
        let events = JSON( data: data )
        
        self.events = events[ "data" ].arrayValue
        refreshControl!.endRefreshing()
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
        Navigator.goTo( "addEventView", vc: self )
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
        
        self.present( popView )
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if ( identifier == "eventDetailsSegue" && events.count > 0 ) {
            return true
        } else {
            _displayAddScreen()
            return false
        }
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
