//
//  eventOptionsMenuViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 23/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class EventOptionsMenuViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventID: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        eventTitle.delegate       = self
        eventDescription.delegate = self
        
        eventDescription.returnKeyType = .Continue
        eventTitle.returnKeyType       = .Next
        
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
    KEYBOARD
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if ( textField == eventTitle ) {
            eventDescription.becomeFirstResponder()
        }
        
        return false
    }
    
    func textViewdDidBeginEditing(textView: UITextView)
    {
        if ( textView == eventDescription ) {
            scrollView.scrollContent()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if ( text == "\n" ) {
            textView.resignFirstResponder()
            scrollView.cancelKeyboard()
            
            return false
        }
        
        return true
    }
}
