//
//  eventOptionsMenuViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 23/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class EventOptionsMenuViewController: UIViewController, UINavigationControllerDelegate
{

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventID: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var currentEvent: JSON!
    let ModelEvent = Event()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setNavigationButtons()
        _loadData()
        _setUI()
    }
    
    /*
    LIIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
        PRIVATE
    */
    private func _setNavigationButtons()
    {
        let shareImg = UIImage( named: "share-icon" )
        let shareBtn = UIButton(type: .Custom )
        
        shareBtn.addTarget( self, action: "_shareEvent:", forControlEvents: UIControlEvents.TouchUpInside )
        shareBtn.setImage( shareImg, forState: .Normal )
        shareBtn.sizeToFit()
        
        let shareBtnItem = UIBarButtonItem( customView: shareBtn )
        
        if ( User.isOwner( currentEvent[ "user_id" ] ) ) {
            let deleteImg = UIImage( named: "delete-icon" )
            let deleteBtn = UIButton(type: .Custom )
            
            deleteBtn.addTarget( self, action: "_deleteEvent:", forControlEvents: UIControlEvents.TouchUpInside )
            deleteBtn.setImage( deleteImg, forState: .Normal )
            deleteBtn.sizeToFit()
            
            let deleteBtnItem = UIBarButtonItem( customView: deleteBtn )
            self.navigationItem.setRightBarButtonItems( [ shareBtnItem, deleteBtnItem ], animated: true )
        } else {
            self.navigationItem.setRightBarButtonItems( [ shareBtnItem ], animated: true )
        }
        
    }
    
    func _shareEvent(sender: AnyObject)
    {
        let shareVC = UIActivityViewController( activityItems: [ eventID.text! ], applicationActivities: nil )
        presentViewController( shareVC, animated: true, completion: nil )
    }

    func _deleteEvent(sender: AnyObject)
    {
        self.alert( "Supprimer l'évènement", message: "Voulez-vous vraiment supprimer cet évènement ?", buttonText: "Oui", cancelButton: "Oula non !" ) {
            
            self.ModelEvent.delete( self.eventID.text! ) {
                dispatch {
                    Navigator.goTo( "eventsListView", vc: self )
                }
            }
        }
        
    }
    
    private func _setUI()
    {
        UIHelper.formatBtn( saveBtn )
        UIHelper.formatTextArea( eventDescription )
        UIHelper.formatInput( eventTitle )
        
        self.title = "Infos de l'évènement"
    }
    
    private func _loadData()
    {
        eventTitle.text       = currentEvent[ "title" ] .string
        eventDescription.text = currentEvent[ "description" ].string
        eventID.text          = currentEvent[ "uuid" ].string
    }
    
    func _goBack(sender: UIBarButtonItem)
    {
        self.navigationController?.popToRootViewControllerAnimated( true )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
