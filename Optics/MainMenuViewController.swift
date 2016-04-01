//
//  MainMenuViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 20/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var user: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _loadData()
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
    @IBAction func logoutBtnTapped(sender: AnyObject)
    {
        User.logout()
        
        Navigator.goTo( "loginView", vc: self )
    }
    
    /*
        PRIVATE
     */
    private func _loadData()
    {
        self.navigationController?.title = "Menu"
        
        User().getSettings {
            data in
            self.user = JSON( data: data )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "accountSegue" ) {
            let accountController = segue.destinationViewController as! AccountViewController
            
            accountController.user = user
        }
    }
}