//
//  AddEventViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 21/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    
    let ModelEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
    }
    
    @IBAction func titleFieldTapped(sender: AnyObject)
    {
        self.title = eventTitleField.text
    }
    
    @IBAction func addBtnTapped(sender: AnyObject)
    {
        let title = Str.trim( eventTitleField.text! )
        let description = Str.trim( eventDescriptionField.text )
        
        ModelEvent.add( title, description: description ) {
            dispatch {
                let eventListVC = self.storyboard?.instantiateViewControllerWithIdentifier( "eventsListView" )
                self.navigationController!.pushViewController( eventListVC!, animated: true )
            }
        }
    }
    
    private func _setUI()
    {
        UIHelper.formatBtn( addBtn )
        UIHelper.formatInput( eventTitleField )
        UIHelper.formatTextArea( eventDescriptionField )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
