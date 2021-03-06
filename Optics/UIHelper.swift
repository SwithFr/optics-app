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
    // COLORS
    static let white        = UIColor( red:1.00, green:1.00, blue:1.00, alpha:1.0 )
    static let black        = UIColor( red:0.07, green:0.07, blue:0.07, alpha:1.0 )
    static let green        = UIColor( red:0.44, green:0.83, blue:0.60, alpha:1.0 )
    static let red          = UIColor( red:0.94, green:0.32, blue:0.26, alpha:1.0 )
    static let grey         = UIColor( red:0.58, green:0.60, blue:0.60, alpha:1.0 )
    static let transparent  = UIColor( red:0.00, green:0.00, blue:0.00, alpha:0.0 )
    
    // UTILS
    static let width  = CGFloat( 1.0 )
    
    static func formatInput(input: UITextField, withLeftPadding: Bool = true)
    {
        input.backgroundColor   = transparent
        input.textColor         = white
        input.frame.size.height = 30
        
        _borderBottom( input )
        
        if ( withLeftPadding ) {
            _setLeftPadding( input )
        }
        
    }
    
    static private func _setLeftPadding(input: UITextField)
    {
        let paddingView = UIView( frame: CGRectMake( 0, 0, 30, input.frame.height ) )
        
        input.leftView     = paddingView
        input.leftViewMode = .Always
    }
    
    static private func _borderBottom(input: UITextField)
    {
        let border = CALayer()
        
        border.borderColor = red.CGColor
        border.frame       = CGRect( x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height )
        border.borderWidth = width
        
        input.layer.addSublayer( border )
        input.layer.masksToBounds = true
    }
    
    static func formatBtn(btn: UIButton, radius: Int=20)
    {
        btn.layer.cornerRadius = CGFloat(radius)
    }
    
    static func formatRoundedImage(img: UIImageView, radius: CGFloat, color: UIColor, border: CGFloat)
    {
        img.layer.cornerRadius    = radius
        img.layer.borderWidth     = border
        img.layer.backgroundColor = black.CGColor
        img.layer.borderColor     = color.CGColor
        img.clipsToBounds         = true
    }
    
    static func formatTextArea(text: UITextView, withBorderRadius: Bool = true)
    {
        text.backgroundColor    = UIColor.clearColor()
        text.layer.borderWidth  = width
        text.layer.borderColor  = red.CGColor
        text.textColor          = white

        if ( withBorderRadius ) {
            text.layer.cornerRadius = CGFloat(5)
        }
    }

}