//
//  RegisterViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 19/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate
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
    
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
        
        ModelUser.register( login, password: password, confirm: confirm, completionHandler: {
            dispatch_async( dispatch_get_main_queue() ) {
                self.dismissViewControllerAnimated( true, completion: nil )
            }
        } ) {
            errorType in
            dispatch_async( dispatch_get_main_queue() ) {
                if ( errorType == "connexion error" ) {
                    self.error( "Erreur", message: "Une erreur est survenue, veuillez réessayer.", buttonText: "Ok" )
                } else if ( errorType == "empty field" ) {
                    self.error( "Infos manquantes", message: "Veuillez remplir tous les champs.", buttonText: "Je complète" )
                } else if ( errorType == "validation error" ) {
                    self.error( "Identifiant indisponnible", message: "Cet identifiant est déjà utilisé.", buttonText: "J'en choisi un autre" )
                }
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
