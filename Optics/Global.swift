//
//  Global.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

// Dispatch closure in main thread
func dispatch(completion: () -> Void)
{
    dispatch_async( dispatch_get_main_queue() ) {
        completion()
    }
}

func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    
    
    if NSJSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }catch {
            
            print("error")
            //Access error here
        }
        
    }
    
    return ""
}

// Temporary method for developement!
func getBaseUrl() -> String
{
    let deviceName = UIDevice.currentDevice().name
        
    var baseUrl = ""
        
    switch deviceName {
        default:
            baseUrl = "http://api.optics.swith.fr:2345/"
            break
    }
    
    return baseUrl
}