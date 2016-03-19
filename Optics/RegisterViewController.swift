//
//  RegisterViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 19/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    let ModelUser = User()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
    }

    @IBAction func registerBtnTapped(sender: AnyObject)
    {
        _register()
    }
    
    @IBAction func goBackLoginBtnTapped(sender: AnyObject)
    {
        Navigator.goBack( self )
    }
    
    private func _setUI()
    {
        UIHelper.formatBtn( registerBtn )
        UIHelper.formatInput( loginField )
        UIHelper.formatInput( passwordField )
        UIHelper.formatInput( confirmField )
        
        loginField.delegate         = self
        passwordField.delegate      = self
        confirmField.delegate       = self
    }
    
    private func _register()
    {
        let login    = loginField.text!
        let password = passwordField.text!
        let confirm  = confirmField.text!
        
        ModelUser.register( login, password: password, confirm: confirm ) {
            dispatch_async( dispatch_get_main_queue() ) {
                self.dismissViewControllerAnimated( true, completion: nil )
                //Navigator.goTo( "loginView", vc: self )
            }
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if ( textField == loginField ) {
            passwordField.becomeFirstResponder()
        } else if ( textField == passwordField ) {
            confirmField.becomeFirstResponder()
        } else if ( textField == confirmField ) {
            _register()
            self.view.endEditing( true )
        }
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
