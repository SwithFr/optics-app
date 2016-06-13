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
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ModelUser = User()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
        hideKeyboardWhenTappedAround()
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
    @IBAction func registerBtnTapped(sender: AnyObject)
    {
        _register()
    }

    @IBAction func goBackLoginBtnTapped(sender: AnyObject)
    {
        if self.navigationController != nil {
            Navigator.goBack( self )
        }
        
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier( "loginView" )
        self.present( loginVC! )
    }
    
    /*
        PRIVATE
    */
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
            dispatch {
                self.ModelUser.login( login, password: password, completionHandler: {
                    dispatch {
                        self.success( "Compte créé", message: "Votre compte a été créé, vous êtes maintenant connecté", buttonText: "Cool" ) {
                            let eventListVC = self.storyboard?.instantiateViewControllerWithIdentifier( "eventsListView" ) as! EventsListTableViewController
                            let navigationController = UINavigationController( rootViewController: eventListVC )
                            
                            self.present( navigationController )
                        }
                    }
                }, errorHandler: {_ in } )
            }
        } ) {
            errorType in
            dispatch {
                if ( errorType == "connexion error" ) {
                    self.error( "Erreur", message: "Une erreur est survenue, veuillez réessayer.", buttonText: "Ok", completion: nil )
                } else if ( errorType == "empty field" ) {
                    self.error( "Infos manquantes", message: "Veuillez remplir tous les champs.", buttonText: "Je complète", completion: nil )
                } else if ( errorType == "validation error" ) {
                    self.error( "Identifiant indisponnible", message: "Cet identifiant est déjà utilisé.", buttonText: "J'en choisi un autre", completion: nil )
                }
            }
        }

    }
    
    /*
        KEYBOARD
    */
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
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if ( textField == confirmField ) {
            scrollView.scrollContent()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        scrollView.cancelKeyboard()
    }


}
