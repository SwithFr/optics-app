//
//  Comment.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

class Comment: Model
{
    // Add a comment to a picture
    func add(comment: String, pictureid: String, eventid: String, next: (data: NSData) -> Void)
    {
        self.setData( "comment=\(comment)" )
        self.setParams( [ "pictureid": pictureid, "eventid": eventid ] )
        self.post( "comments", authenticate: true) {
            error, data in
            
            if ( error != nil ) {
                print( "Error when add comment" )
            }
            
            next( data: data )
        }
    }
    
    // Get comment for a picture
    func getAllFromPicture( pictureid: String, next: (data: NSData) -> Void )
    {
        self.setParams( [ "pictureid": pictureid ] )
        self.get( "comments", authenticate: true) {
            error, data in
            
            if ( error != nil ) {
                print( "Error when getting comments" )
            }
            
            dispatch {
                next( data: data )
            }
        }
        
    }
}