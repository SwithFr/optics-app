//
//  FriendDetailsViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 04/05/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class FriendDetailsViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    /*
        LIGHT STATUS BAR
     */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
}
