//
//  User.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

class User : Model
{
    // Log in an user
    func login(login: String, password: String, completionHandler: () -> Void)
    {
        if ( login.isEmpty || password.isEmpty ) {
            print("un des deux est vide")
        } else {
            self.setData( "login=\(login)&password=\(password)" )
            self.post( "users/login", authenticate: nil ) {
                error, data in
                if error == nil {
                    let data = JSON( data: data )
                    let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    user.setValue( data[ "data"][ "token" ].string, forKey: "USER_TOKEN")
                    user.setValue( data[ "data" ][ "id" ].int, forKey: "USER_ID" )
                    user.synchronize()
                    
                    completionHandler()
                } else {
                    print( "Erreur lors de la connexion" )
                    exit( 1 )
                }
            }
        }
        
    }
    
    // Register a new user
    func register(login: String, password: String, confirm: String, completionHandler: () -> Void)
    {
        if ( login.isEmpty || password.isEmpty || confirm.isEmpty ) {
            print("un des trois est vide")
        } else if ( password != confirm ) {
            print("confirmation nom valide")
        } else {
            self.setData( "login=\(login)&password=\(password)" )
            self.post( "users/register", authenticate: nil ) {
                error, data in
                let response = JSON( data: data )
                
                if error == nil {
                    if ( response["error"] != false  ) {
                        print( response["error"] )
                    } else {
                        completionHandler()
                    }
                } else {
                    print( "Erreur lors de l'inscription" )
                }
            }
        }
        
    }

    
    // Check if current user is the owner of a ressource
    static func isOwner(ownerID: JSON) -> Bool
    {
        return ownerID.rawString()! == getUserProperty( "USER_ID" )!.stringValue
    }
    
    // Get current user
    static func getCurrentUser() -> NSUserDefaults {
        let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        return user
    }
    
    // Get Current user property (token or id)
    static func getUserProperty(key: String) -> AnyObject? {
        let user = getCurrentUser()
        return user.valueForKey( key )
    }
    
    // Check if a user is authenticated
    static func isAuthenticated() -> Bool {
        return getUserProperty( "USER_TOKEN" ) != nil
    }
    
    // Disconnect the user
    static func logout() -> Void {
        if ( isAuthenticated() ) {
            let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            user.removeObjectForKey( "USER_ID" )
            user.removeObjectForKey( "USER_TOKEN" )
        }
    }
    
}