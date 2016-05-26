//
//  Application.swift
//  Optics
//
//  Created by Jérémy Smith on 26/05/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

class Application
{
    
    static func UserHasAccount() -> Bool?
    {
        let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if user.objectForKey( "HAS_ACCOUNT" ) != nil {
            return true
        }
        
        return false
    }
    
    static func getFirstView() -> String
    {
        if !User.isAuthenticated() && UserHasAccount()! {
            return "loginView"
        } else if !User.isAuthenticated() && !Application.UserHasAccount()! {
            return "registerView"
        }
        
        return ""
    }
    
}