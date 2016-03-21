//
//  StringHelper.swift
//  Optics
//
//  Created by Jérémy Smith on 21/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation

public struct Str
{
    static func trim(string: String) -> String
    {
        return string.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceCharacterSet() )
    }
}