//
//  UIViewControllerExtensions.swift
//  Optics
//
//  Created by Jérémy Smith on 27/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoader(msg: String)
    {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let message   = UILabel( frame: CGRect( x: 50, y: 0, width: 200, height: 50 ) )
        let container = UIView( frame: CGRect( x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50 ) )
        
        actInd.activityIndicatorViewStyle = .White
        actInd.frame                      = CGRect( x: 0, y: 0, width: 50, height: 50 )
        message.text                      = msg
        message.textColor                 = UIColor.whiteColor()
        container.layer.cornerRadius      = 15
        container.backgroundColor         = UIColor( white: 0, alpha: 0.7 )
        container.tag                     = 1000
        actInd.startAnimating()
        container.addSubview( actInd )
        container.addSubview( message )
        view.addSubview( container )
        actInd.startAnimating()
    }
    
    func hideLoader()
    {
        if let viewWithTag = self.view.viewWithTag( 1000 ) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func present(target: UIViewController)
    {
        self.presentViewController( target, animated: true, completion: nil )
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}