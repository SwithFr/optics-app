//
//  Picture.swift
//  Optics
//
//  Created by Jérémy Smith on 22/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class Picture: Model
{
    func getAllFromEventID(sEventID: String, completionHandler: (data: NSData) -> Void)
    {
        self.setParams( [ "eventid": sEventID ] )
        self.get( "pictures" , authenticate: true) {
            error, data in
            if error != nil {
                print("error")
            }
                
            dispatch {
                completionHandler( data: data )
            }
        }
    }
    
    func uploadImg(sEventID: String, img: UIImage, completionHandler: (data: NSData) -> Void)
    {
        self.uploadImage( sEventID ,image: img ) {
            error, data in
            if error != nil {
                print( "Error on upload" )
                return
            }
            
            dispatch {
                completionHandler( data: data )
            }
        }
    }
    
    func delete(sPictureID: String, completionHandler: () -> Void)
    {
        self.delete( "pictures/\(sPictureID)", authenticate: true) {
            error, data in
            
            if error != nil {
                print("error on deletion")
                return
            }
            
            dispatch {
                completionHandler()
            }
        }
    }
    
    static func getImageFromUrl(url: String) -> UIImage
    {
        let url  = NSURL( string: url )
        let data = NSData( contentsOfURL: url! )
        
        return UIImage( data: data! )!
    }
    
}