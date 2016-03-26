//
//  ImageHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class Image
{

    static func decode(image: String) -> UIImage
    {
        let decodedData = NSData( base64EncodedString: String( image ), options: NSDataBase64DecodingOptions( rawValue: 0 ) )
        
        return UIImage( data: decodedData! )!
    }
    
    static func blur(image: UIImageView)
    {
        let darkBlur = UIBlurEffect( style: UIBlurEffectStyle.Dark )
        let blurView = UIVisualEffectView( effect: darkBlur )
        
        blurView.frame = image.bounds
        image.addSubview(blurView)
    }
    
}