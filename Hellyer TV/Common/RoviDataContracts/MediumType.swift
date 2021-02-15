//
//  MediumType.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

enum MediumType: String, JSONSerializable {
    
    ///Film.
    case file = "Film"
    ///Music.
    case music = "Music"
    ///None.
    case none = "None"
    ///Radio.
    case radio = "Radio"
    ///Sports.
    case sports = "Sports"
    ///Theater.
    case theater = "Theater"
    ///Television.
    case tv = "TV"
}
