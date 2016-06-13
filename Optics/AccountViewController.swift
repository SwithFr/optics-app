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
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ModelUser = User()
    
    var user: JSON!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _setUI()
        _loadData()
        hideKeyboardWhenTappedAround()
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
        
        UIHelper.formatRoundedImage( userAvatar, radius: 50, color: UIHelper.red, border: 2 )
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate  = self
    }
    
    private func _loadData()
    {
        self.usernameField.text = user[ "data" ][ "login" ].string
        self.userAvatar.image   = UIImage( named: "img-placeholer.png" )
        
        Picture.getImgFromUrl( String( user[ "data" ][ "avatar" ] ) ) {
            data, response, error in
            dispatch {
                self.userAvatar.image = UIImage( data: data! )
            }
        }
    }
    
    /*
        KEYBOARD
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if ( textField == passwordField ) {
            confirmField.becomeFirstResponder()
        } else {
            self.view.endEditing( true )
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if ( textField == confirmField ) {
            scrollView.scrollContent()
        }
    }

    func textFieldDidEndEditing(textField: UITextField)
    {
        if ( textField == confirmField ) {
            scrollView.cancelKeyboard()
        }
    }
}
