//
//  ArrayExtensions.swift
//  Optics
//
//  Created by Jérémy Smith on 29/04/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject(object: JSON){
        self.removeAtIndex( self.indexOf {
            element -> Bool in
                print(element)
                return true
            }!)
    }
}