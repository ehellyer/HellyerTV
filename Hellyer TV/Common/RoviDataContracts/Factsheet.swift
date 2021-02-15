//
//  Factsheet.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Factsheet: JSONSerializable {
    
    ///Life and career information about the person in less than 8000 characters.
    var Details: String
    
    /**
     Database ID for the language the factsheet is written in. The language is determined by the language specified in the request locale parameter. If no factsheets are available in that language for the celebrity, they are returned in English.
     */
    var LanguageId: String
    
    ///Type of factsheet in less than 64 characters.
    var type: String
}
