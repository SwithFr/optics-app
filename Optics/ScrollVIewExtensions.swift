//
//  ScrollVIewExtensions.swift
//  Optics
//
//  Created by Jérémy Smith on 26/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView
{
    func cancelKeyboard()
    {
        self.setContentOffset( CGPointMake( 0, 0 ), animated: true )
    }
    
    func scrollContent()
    {
        setContentOffset( CGPointMake( 0, 200 ), animated: true  )
    }
}