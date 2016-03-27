//
//  ImageHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreMedia

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

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}