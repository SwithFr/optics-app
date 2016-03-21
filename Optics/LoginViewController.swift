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
    
    let ModelUser = User()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
        _hideBackButton()
        
    }
    
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }

    @IBAction func loginBtnTapped(sender: AnyObject)
    {
        _logUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    // Do the login action
    private func _logUser()
    {
        let login = loginField.text!
        let password = passwordField.text!
        
        ModelUser.login( login, password: password, completionHandler: {
            dispatch_async( dispatch_get_main_queue() ) {
                //let eventListVC = EventsListTableViewController()
                let eventListVC = self.storyboard?.instantiateViewControllerWithIdentifier( "eventsListView" ) as! EventsListTableViewController
                let navigationController = UINavigationController( rootViewController: eventListVC )
                
                self.presentViewController( navigationController, animated: true, completion: nil )
            }
        }) {
            errorType in
            dispatch_async( dispatch_get_main_queue() ) {                
                if ( errorType == "error connexion" ) {
                    self.error( "Erreur", message: "Une erreur est survenue, veuillez réessayer.", buttonText: "Ok" )
                } else if ( errorType == "empty field" ) {
                    self.error( "Infos manquantes", message: "Veuillez remplir tous les champs.", buttonText: "Je complète" )
                } else if ( errorType == "unknown user" ) {
                    self.error( "Utilisateur introuvable", message: "Veuillez verifier vos informations.", buttonText: "Nouvel essai" )
                }
            }
        }
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
