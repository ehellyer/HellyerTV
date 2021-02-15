//
//  AKA.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct AKA: JSONSerializable {
    
    ///First name in less than 100 characters.
    var FirstName: String
    
    ///Last name in less than 100 characters.
    var LastName: String
}
