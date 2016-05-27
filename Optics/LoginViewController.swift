//
//  LoginViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 18/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ModelUser = User()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
        _hideBackButton()
        
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
    @IBAction func loginBtnTapped(sender: AnyObject)
    {
        _logUser()
    }
    
    /*
        KEYBOARD
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if ( textField == loginField ) {
            passwordField.becomeFirstResponder()
        } else if ( textField == passwordField ) {
            _logUser()
            self.view.endEditing( true )
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if ( textField == passwordField ) {
            scrollView.scrollContent()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        scrollView.cancelKeyboard()
    }
    
    /*
        PRIVATE
    */
    // Set the UI with good appearance
    private func _setUI()
    {
        UIHelper.formatInput( loginField )
        UIHelper.formatInput( passwordField )
        UIHelper.formatBtn( loginBtn )
        
        loginField.returnKeyType    = .Next
        passwordField.returnKeyType = .Done
        loginField.delegate         = self
        passwordField.delegate      = self
        
        
        self.navigationController?.navigationBarHidden = true
    }
    
    private func _hideBackButton()
    {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
    
    // Do the login action
    private func _logUser()
    {
        let login = loginField.text!
        let password = passwordField.text!
        
        ModelUser.login( login, password: password, completionHandler: {
            dispatch {
                self.success( "Super !", message: "Vous êtes connecté", buttonText: "Cool" ) {                    
                    let eventListVC = self.storyboard?.instantiateViewControllerWithIdentifier( "eventsListView" ) as! EventsListTableViewController
                    let navigationController = UINavigationController( rootViewController: eventListVC )
                    
                    self.present( navigationController )
                }
            }
        }) {
            errorType in
            dispatch {                
                if ( errorType == "error connexion" ) {
                    self.error( "Erreur", message: "Une erreur est survenue, veuillez réessayer.", buttonText: "Ok", completion: nil )
                } else if ( errorType == "empty field" ) {
                    self.error( "Infos manquantes", message: "Veuillez remplir tous les champs.", buttonText: "Je complète", completion: nil )
                } else if ( errorType == "unknown user" ) {
                    self.error( "Utilisateur introuvable", message: "Veuillez verifier vos informations.", buttonText: "Nouvel essai", completion: nil )
                }
            }
        }
    }
}