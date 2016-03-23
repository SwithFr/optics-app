//
//  eventOptionsMenuViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 23/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class EventOptionsMenuViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventID: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var currentEvent: JSON!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //_setNavigationButtons()
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
        let returnImg = UIImage( named: "back-icon" )
        let returnBtn = UIButton(type: .Custom )
        let returnBtnItem = UIBarButtonItem( customView: returnBtn )
        
        returnBtn.addTarget( self, action: "_goBack:", forControlEvents: UIControlEvents.TouchUpInside )
        returnBtn.setImage( returnImg, forState: .Normal )
        returnBtn.sizeToFit()
        
        self.navigationItem.setLeftBarButtonItems( [ returnBtnItem ], animated: true )
    }
    
    private func _setUI()
    {
        UIHelper.formatBtn( saveBtn )
        UIHelper.formatTextArea( eventDescription )
        UIHelper.formatInput( eventTitle )
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
