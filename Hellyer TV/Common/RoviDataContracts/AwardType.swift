//
//  AwardType.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

enum AwardType: String, JSONSerializable {
    
    ///Emmy.
    case emmy = "Emmy"
        
    ///Golden Globe.
    case glodenGlobe = "Golden Globe"
    
    ///Grammy.
    case grammy = "Grammy"
    
    ///Peabody.
    case peabody = "Peabody"
    
    ///People's Choice Awards.
    case peopleChoiceAwards = "People's Choice Awards"
    
    ///Oscar.
    case oscar = "Oscar"
    
    ///Tony.
    case tony = "Tony"
}
