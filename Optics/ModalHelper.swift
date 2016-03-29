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
    
    func chooseCameraOrGallery(actionForCamera: () -> Void, actionForGallery: () -> Void)
    {
        let alert = UIAlertController( title: "Choisir une image", message: nil, preferredStyle: .ActionSheet )
        
        let cameraAction = UIAlertAction( title: "Prendre une photo", style: .Default )
        {
            UIAlertAction in
            actionForCamera()
        }
        let gallaryAction = UIAlertAction( title: "Choisir une existante", style: .Default )
        {
            UIAlertAction in
            actionForGallery()
        }
        let cancelAction = UIAlertAction( title: "Cancel", style: .Cancel )
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController( alert, animated: true, completion: nil )
    }
    
    func alert(title: String, message: String, buttonText: String, cancelButton: String, completion: () -> Void)
    {
        SweetAlert().showAlert( title, subTitle: message, style: .None, buttonTitle: buttonText, buttonColor: UIHelper.green, otherButtonTitle: "Annuler" ) {
            isOtherButton in
            if ( isOtherButton ) {
                completion()
            }
        }
    }
    
    func askBeforeDelete(title: String, message: String, buttonText: String, otherButtonTitle: String, completion: () -> Void)
    {
        SweetAlert().showAlert( title, subTitle: message, style: .None, buttonTitle: buttonText, buttonColor: UIHelper.green, otherButtonTitle: otherButtonTitle, otherButtonColor: UIHelper.red ) {
            isOtherButton in
            if ( isOtherButton ) {
                completion()
            }
        }
    }
    
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