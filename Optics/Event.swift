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
                
            if ( error != nil ) {
                errorHandler()
            }
                
            dispatch {
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
                
                if ( error != nil ) {
                    print( "error" )
                    return
                }
                
                dispatch {
                    print("RESPONSE ADD EVENT")
                    print(JSON(data: data))
                    completionHandler()
                }
            }
        }

    }
    
    // Delete an event
    func delete(sEventID: String, completionHandler: () -> Void)
    {
        self.delete( "events/\(sEventID)", authenticate: true) {
            error, data in
            
            if ( error != nil ) {
                print("error on deletion")
                return
            }
            
            dispatch {
                print("RESPONSE DELETE EVENT")
                print(JSON(data: data))
                completionHandler()
            }
        }
    }
    
    // Update event infos
    func update(sEventID: String, title: String, description: String, completionHandler: (data: NSData) -> Void)
    {
        let data = [
            "title": title,
            "description": description
        ]
        
        self.setData( JSONStringify( data ) )
        self.update( "events/\(sEventID)", authenticate: true ) {
            error, data in
            if ( error == nil ) {
                dispatch {
                    print("RESPONSE UPDATE EVENT")
                    print(JSON(data: data))
                    completionHandler( data: data )
                }
            }
        }
    }
    
    // Join an event
    func join(iEventID: String, completionHandler: (data: NSData) -> Void)
    {
        self.get("events/join/\(iEventID)", authenticate: true) {
            error, data in
            // TODO: Verifications ALREADY_JOINED...
            dispatch {
                completionHandler( data: data )
            }
        }
    }
}