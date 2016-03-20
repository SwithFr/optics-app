//
//  ModalHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 19/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

extension UIViewController
{
    
//    func errorAlert(title: String, message: String)
//    {
//        let alertView = _alert( title, message: message, style: "error" )
//        let defaultAction = UIAlertAction( title: "Ok", style: .Default, handler: nil )
//        
//        alertView.addAction( defaultAction )
//        presentViewController( alertView, animated: true, completion: nil )
//    }
//    
//    private func _alert(title: String, message: String, style: String) -> UIAlertController
//    {
//        let alertStyle: UIAlertControllerStyle
//        
//        switch style {
//        case "error":
//            alertStyle = .Alert
//        default:
//            alertStyle = .Alert
//        }
//        
//        let alertView = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: alertStyle
//        )
//        
//        return alertView
//    }
    
    func error(title: String, message: String, buttonText: String)
    {
        let alert = JSSAlertView().show(
            self,
            title: title,
            text:  message,
            buttonText: buttonText,
            color: UIHelper.red
        )
        
        alert.setTextTheme( .Light )
        alert.setTextFont( "Raleway-Light" )
        alert.setTextFont( "Raleway-Light" )
        alert.setButtonFont( "Raleway-Light" )
        
    }
    
}