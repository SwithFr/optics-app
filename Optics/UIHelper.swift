//
//  UIHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

public struct UIHelper
{
    static let green        = UIColor( red:0.75, green:0.89, blue:0.86, alpha:1.0 )
    static let black        = UIColor( red:0.10, green:0.12, blue:0.16, alpha:1.0 )
    static let red          = UIColor( red:0.94, green:0.32, blue:0.26, alpha:1.0 )
    static let grey         = UIColor( red:0.80, green:0.80, blue:0.80, alpha:1.0 )
    static let transparent  = UIColor( red:0, green:0, blue:0, alpha:0 )
    
    static func formatInput(input: UITextField)
    {
        input.backgroundColor = UIColor.clearColor()
        input.layer.borderWidth = 2
        input.layer.borderColor = green.CGColor
        input.layer.cornerRadius = CGFloat(5)
        input.textColor = green
    }
    
    static func formatBtn(btn: UIButton)
    {
        btn.layer.cornerRadius = CGFloat(20)
    }
    
    static func formatRoundedImage(img: UIImageView, radius: CGFloat, color: UIColor, border: CGFloat)
    {
        img.layer.cornerRadius = radius
        img.layer.borderWidth = border
        img.layer.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).CGColor
        img.layer.borderColor = color.CGColor
        img.clipsToBounds = true
    }
    
    static func formatTextArea(text: UITextView)
    {
        text.backgroundColor = UIColor.clearColor()
        text.layer.borderWidth = 2
        text.layer.borderColor = green.CGColor
        text.layer.cornerRadius = CGFloat(5)
        text.textColor = green
    }

}