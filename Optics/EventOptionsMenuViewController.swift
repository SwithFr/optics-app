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
        
        navigationController?.delegate = self
        
        _setNavigationButtons()
        _loadData()
        _setUI()
    }
    
    /*
        LIGHT STATUS BAR
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
        ACTIONS
     */
    @IBAction func saveBtnTapped(sender: AnyObject)
    {
        ModelEvent.update( String( currentEvent[ "uuid" ] ), title: eventTitle.text!, description: eventDescription.text! ) {
            data in
            dispatch {
                self.currentEvent = JSON( data: data )[ "data" ]
                Navigator.goBack( self )
            }
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    {
        if let controller = viewController as? EventDetailsTableViewController {
            controller.currentEvent = currentEvent
        }
    }
    
    /*
        PRIVATE
     */
    private func _setNavigationButtons()
    {
        let shareBtnItem = Button.forge( self, image: "share-icon", action: #selector(EventOptionsMenuViewController._shareEvent(_:)) )
        
        if ( User.isOwner( currentEvent[ "user_id" ] ) ) {
            let deleteBtnItem = Button.forge( self, image: "delete-icon", action: #selector(EventOptionsMenuViewController._deleteEvent(_:)) )
            let spacer        = Button.space( 25 )
            
            self.navigationItem.setRightBarButtonItems( [ shareBtnItem, spacer, deleteBtnItem ], animated: true )
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
        if ( User.isOwner( currentEvent[ "user_id" ] ) ) {
            UIHelper.formatBtn( saveBtn )

            eventTitle.delegate       = self
            eventDescription.delegate = self
            
            eventDescription.returnKeyType = .Continue
            eventTitle.returnKeyType       = .Next
        } else {
            saveBtn.hidden                         = true
            eventDescription.editable              = false
            eventTitle.allowsEditingTextAttributes = false
        }
        
        UIHelper.formatTextArea( eventDescription )
        UIHelper.formatInput( eventTitle, withLeftPadding: false )
        
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if ( !User.isOwner( currentEvent[ "user_id" ] ) ) {
            return false
        }
        
        return true
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
