//
//  AddEventViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 21/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ModelEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
    }
    
    /*
        LIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    /*
        ACTIONS
    */
    @IBAction func titleFieldTapped(sender: AnyObject)
    {
        self.title = eventTitleField.text
    }
    
    @IBAction func addBtnTapped(sender: AnyObject)
    {
        let title       = Str.trim( eventTitleField.text! )
        let description = Str.trim( eventDescriptionField.text )
        
        ModelEvent.add( title, description: description ) {
            dispatch {
                let eventListVC = self.storyboard?.instantiateViewControllerWithIdentifier( "eventsListView" )
                
                self.navigationController!.pushViewController( eventListVC!, animated: true )
            }
        }
    }
    
    /*
        PRIVATE
    */
    private func _setUI()
    {
        UIHelper.formatBtn( addBtn )
        UIHelper.formatInput( eventTitleField )
        UIHelper.formatTextArea( eventDescriptionField )
        
        eventTitleField.returnKeyType       = .Next
        eventDescriptionField.returnKeyType = .Done
        eventDescriptionField.delegate      = self
        eventTitleField.delegate            = self
    }
    
    /*
        KEYBOARD
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if ( textField == eventTitleField ) {
            eventDescriptionField.becomeFirstResponder()
        }
        
        return false
    }
    
    func textViewdDidBeginEditing(textView: UITextView)
    {
        if ( textView == eventDescriptionField ) {
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
