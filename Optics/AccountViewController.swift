//
//  AccountViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 30/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    let ModelUser = User()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
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
    @IBAction func saveBtnTapped(sender: AnyObject)
    {
        ModelUser.updateSettings( usernameField.text!, password: passwordField.text! ) {
            data in
            let user = JSON( data: data )
            self.usernameField.text = user[ "data" ][ "newLogin" ].string
        }
    }
    
    /*
        PRIVATE
     */
    private func _setUI()
    {
        UIHelper.formatBtn( saveBtn )
        UIHelper.formatInput( usernameField )
        UIHelper.formatInput( passwordField )
        UIHelper.formatInput( confirmField )
        UIHelper.formatRoundedImage( userAvatar, radius: 100, color: UIHelper.red, border: 2 )
    }
    
    private func _loadData()
    {
        ModelUser.getSettings {
            data in
            let user = JSON( data: data )
            self.usernameField.text = user[ "data" ][ "login" ].string
            self.userAvatar.image = Picture.getImageFromUrl( String( user[ "data" ][ "avatar" ] ) )
        }
        
    }

}