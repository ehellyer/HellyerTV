//
//  ProgramType.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

enum ProgramType: String, JSONSerializable {
    
    ///Episode in a television series.
    case episode = "Episode"
    
    ///A one-time only program.
    case oneTimeOnly = "One Time Only"
    
    ///A Movie
    case movie = "Movie"
    
    ///A television series.
    case series = "Series"
    
    ///Unkown
    case unknown = "Unkown"
}
