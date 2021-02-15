//
//  Relative.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Relative: JSONSerializable {
    
    ///Name of the relative in less than 100 characters.
    var Name: String
    
    ///Relationship with the celebrity in less than 100 characters.
    var Relationship: String
    
    ///Database ID of this person if information is available. Limited to fewer than 10 characters.
    var RelativeCreditId: String
}
