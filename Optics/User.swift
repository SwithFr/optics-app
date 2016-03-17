//
//  User.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

class User
{
    
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