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
                print("REPONSE UPLOAD")
                print(JSON(data: data))
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
    
    static func getImgFromUrl(url: String, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void))
    {
        let route = NSURL( string: url )
        
        NSURLSession.sharedSession().dataTaskWithURL( route! ) {
            data, response, error in
                completion( data: data, response: response, error: error )
            }.resume()
    }
    
}