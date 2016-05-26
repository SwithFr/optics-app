//
//  User.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class User : Model
{
    let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // Log in an user
    func login(login: String, password: String, completionHandler: () -> Void, errorHandler: (errorType: String) -> Void)
    {
        if ( login.isEmpty || password.isEmpty ) {
            errorHandler( errorType: "empty field" )
        } else {
            self.setData( "login=\(login)&password=\(password)" )
            self.post( "users/login", authenticate: nil ) {
                error, data in
                if error == nil {
                    let response = JSON( data: data )
                    
                    if ( response["error"] != false  ) {
                        errorHandler( errorType: "unknown user" )
                    } else {
                        self.user.setValue( response[ "data"][ "token" ].string, forKey: "USER_TOKEN")
                        self.user.setValue( response[ "data" ][ "id" ].int, forKey: "USER_ID" )
                        self.user.setBool( true, forKey: "HAS_ACCOUNT" )
                        self.user.synchronize()
                        
                        completionHandler()
                    }
                    
                    //completionHandler()
                } else {
                    errorHandler( errorType: "error connexion" )
                }
            }
        }
    }
    
    // Register a new user
    func register(login: String, password: String, confirm: String, completionHandler: () -> Void, errorHandler: (errorType: String) -> Void)
    {
        if ( login.isEmpty || password.isEmpty || confirm.isEmpty ) {
            errorHandler( errorType: "empty field" )
        } else if ( password != confirm ) {
            errorHandler( errorType: "confirm failed" )
        } else {
            self.setData( "login=\(login)&password=\(password)" )
            self.post( "users/register", authenticate: nil ) {
                error, data in
                let response = JSON( data: data )
                
                if error == nil {
                    if ( response["error"] != false  ) {
                        errorHandler( errorType: "validation error" )
                    } else {
                        self.user.setBool( true, forKey: "HAS_ACCOUNT" )
                        self.user.synchronize()
                        
                        completionHandler()
                    }
                } else {
                    errorHandler( errorType: "connexion error" )
                }
            }
        }
    }

    // Get current user settings
    func getSettings(completionHandler: (data: NSData) -> Void)
    {
        self.get( "users/settings", authenticate: true ) {
            error, data in
            
            if error != nil {
                print("error")
            } else {
                dispatch {
                    completionHandler( data: data )
                }
            }
        }
    }
    
    // Update current user settings
    func updateSettings(username: String, password: String, completionHandler: (data: NSData) -> Void)
    {
        let data = [
            "login": username,
            "password": password
        ]
        
        self.setData( JSONStringify( data ) )
        self.update( "users/\(User.getUserProperty( "USER_ID" )!)", authenticate: true ) {
            error, data in
            if ( error == nil ) {
                dispatch {
                    print("RESPONSE UPDATE USER")
                    print(JSON(data: data))
                    completionHandler( data: data )
                }
            }
        }
    }
    
    // List all friends or search a user
    func getUsers(friendName: String?, completionHandler: (data: NSData) -> Void)
    {
        var route = "users/friends"
        
        if let searchName = friendName {
            route += "/\(searchName)"
        }
        
        self.get( route, authenticate: true ) {
            error, data in
            
            if error != nil {
                print("error on getting friends")
            } else {
                dispatch {
                    print("RESPONSE GET FRIENDS")
                    print(JSON(data: data))
                    completionHandler( data: data )
                }
            }
        }
    }
    
    // Add a friend
    func addFriend(friendId: Int, completionHandler: (data: NSData) -> Void)
    {
        self.post( "users/friends/\(friendId)", authenticate: true ) {
            error, data in
            if error != nil {
                print("error on adding friend")
            } else {
                dispatch {
                    print("RESPONSE ADD FRIEND")
                    print(JSON(data: data))
                    completionHandler( data: data )
                }
            }

        }
    }
    
    // Remove a friend
    func removeFriend(friendId: Int, completionHandler: (data: NSData) -> Void)
    {
        self.delete( "users/friends/\(friendId)", authenticate: true ) {
            error, data in
            if error != nil {
                print("error on deleting friend")
            } else {
                dispatch {
                    print("RESPONSE DELETE FRIEND")
                    print(JSON(data: data))
                    completionHandler( data: data )
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
    static func getCurrentUser() -> NSUserDefaults
    {
        let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        return user
    }
    
    // Get Current user property (token or id)
    static func getUserProperty(key: String) -> AnyObject?
    {
        let user = getCurrentUser()
        
        return user.valueForKey( key )
    }
    
    // Check if a user is authenticated
    static func isAuthenticated() -> Bool
    {
        return getUserProperty( "USER_TOKEN" ) != nil
    }
    
    // Disconnect the user
    static func logout() -> Void
    {
        if ( isAuthenticated() ) {
            let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            user.removeObjectForKey( "USER_ID" )
            user.removeObjectForKey( "USER_TOKEN" )
        }
    }
    
}