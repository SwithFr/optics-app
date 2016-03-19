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
    func getAll(completionHandler: (data: NSData) -> ())
    {
        self.get( "events", authenticate: true ) {
            error, data in
            dispatch_async( dispatch_get_main_queue() ) {
                
                if error != nil {
                    print( "Erreur lors du chargement de vos évènements" )
                    exit( 1 )
                }
                
                completionHandler(data: data)
            }
        }
    }
}