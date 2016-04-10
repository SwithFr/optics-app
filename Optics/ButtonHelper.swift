//
//  ButtonHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 01/04/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class Button
{

    // create a button
    static func create(type: UIButtonType) -> UIButton
    {
        return UIButton( type: type )
    }
    
    // create button icon
    static func icon(name: String) -> UIImage
    {
        return UIImage( named: name )!
    }
    
    // create bar button item
    static func barItem(button: UIButton) -> UIBarButtonItem
    {
        return UIBarButtonItem( customView: button)
    }
    
    // create a new bar button item
    static func forge(target: UIViewController, image: String, action: Selector, type: UIButtonType = .Custom) -> UIBarButtonItem
    {
        let btn     = self.create( type )
        let icon    = self.icon( image )
        let barItem = self.barItem( btn )
        
        btn.addTarget( target, action: action, forControlEvents: .TouchUpInside )
        btn.setImage( icon, forState: .Normal )
        btn.sizeToFit()
        
        return barItem
    }
    
    static func space(width: CGFloat) -> UIBarButtonItem
    {
        let space = UIBarButtonItem( barButtonSystemItem: .FixedSpace, target: nil, action: nil )
        space.width = width
        
        return space
    }
}