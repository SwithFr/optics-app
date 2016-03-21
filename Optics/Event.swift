//
//  Event.swift
//  Optics
//
//  Created by Jérémy Smith on 18/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

class Event: Model
{
    // Get all event for authenticated user
    func getAll(completionHandler: (data: NSData) -> (), errorHandler: () -> Void)
    {
        self.get( "events", authenticate: true ) {
            error, data in
            dispatch_async( dispatch_get_main_queue() ) {
                
                if error != nil {
                    errorHandler()
                }
                
                completionHandler( data: data )
            }
        }
    }
    
    // Add an event
    func add(title: String, description: String, completionHandler: () -> Void)
    {
        if ( title.isEmpty || description.isEmpty ) {
            // TODO: Verification et erroHandler
            print( "Error" )
        } else {
            self.setData( "title=\(title)&description=\(description)" )
            self.post( "events/create", authenticate: true ) {
                error, data in
                
                if error != nil {
                    print( "error" )
                }
                
                dispatch_async( dispatch_get_main_queue(), {
                    completionHandler()
                } )
            }
        }

    }
    
    // Join an event
    func join(iEventID: String, completionHandler: (data: NSData) -> Void)
    {
        self.get("events/join/\(iEventID)", authenticate: true) {
            error, data in
            // TODO: Verifications
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler( data: data )
            }
        }
    }
}