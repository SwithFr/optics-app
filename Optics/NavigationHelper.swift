//
//  NavigationHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class Navigator
{
    
    static func goTo(viewControllerId: String, vc: UIViewController)
    {
        let targetVC = vc.storyboard?.instantiateViewControllerWithIdentifier( viewControllerId )
        vc.navigationController?.pushViewController( targetVC!, animated: true )
    }
    
    static func closeModal(vc: UIViewController)
    {
        vc.dismissViewControllerAnimated( true, completion: nil )
    }
    
    static func goBack(vc: UIViewController)
    {
        vc.navigationController!.popViewControllerAnimated( true )
    }
    
}