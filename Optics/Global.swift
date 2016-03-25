//
//  Global.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

// Dispatch closure in main thread
func dispatch(completion: () -> Void)
{
    dispatch_async( dispatch_get_main_queue() ) {
        completion()
    }
}