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
    
    static func UserHasAccount()
    {
        let user:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let bHasAccount = user.objectForKey( "HAS_ACCOUNT" ) as? Bool
        
        print(bHasAccount)
    }
    
}