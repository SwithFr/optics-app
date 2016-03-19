//
//  ModalHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 19/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

public struct Modal
{
    static func error(title: String, message: String)
    {
        let vc = UIViewController()
        let alertView = _alert( title, message: message, style: "error" )
        let defaultAction = UIAlertAction( title: "Ok", style: .Default, handler: nil )
        
        alertView.addAction( defaultAction )
        vc.presentViewController( alertView, animated: true, completion: nil )
    }
    
    static private func _alert(title: String, message: String, style: String) -> UIAlertController
    {
        let alertStyle: UIAlertControllerStyle
        
        switch style {
            
        case "error":
            alertStyle = .Alert
        default:
            alertStyle = .Alert
            
        }
        
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: alertStyle
        )
        
        return alertView
    }
}